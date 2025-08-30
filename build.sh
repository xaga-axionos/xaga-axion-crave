#!/usr/bin/env bash
# AxionOS build script for Crave
set -euo pipefail

export BUILD_USERNAME=xaga-axionos
export BUILD_HOSTNAME=crave

echo "==> Reset local manifests"
rm -rf .repo/local_manifests

echo "==> Init AxionOS manifests"
repo init --depth=1 -u https://github.com/AxionAOSP/android.git -b lineage-23.0 --git-lfs

echo "==> Clone local_manifests"
git clone --depth=1 https://github.com/xaga-axionos/local_manifests .repo/local_manifests

echo "==> Prune overridden trees"
rm -rf device/xiaomi/xaga device/xiaomi/mt6895-common device/mediatek/sepolicy_vndr
rm -rf vendor/xiaomi/xaga vendor/xiaomi/mt6895-common vendor/mediatek/ims
rm -rf vendor/firmware vendor/lineage/config vendor/xiaomi/miuicamera-xaga
rm -rf kernel/xiaomi/mt6895
rm -rf hardware/mediatek hardware/xiaomi

echo "==> Repo sync"
/opt/crave/resync.sh

echo "==> Env setup"
. build/envsetup.sh

echo "==> Lunch: axion xaga userdebug gms core"
axion xaga userdebug gms core

JOBS=$(nproc --all)
echo "==> Build: ax -b -j${JOBS}"
ax -b
