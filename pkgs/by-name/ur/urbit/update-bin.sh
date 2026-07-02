#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl

set -euo pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
NIX_DRV="$ROOT/package.nix"
if [ ! -f "$NIX_DRV" ]; then
  echo "ERROR: cannot find urbit in $ROOT"
  exit 1
fi

VERSION=$(curl https://bootstrap.urbit.org/vere/live/last)

prefetch() {
  nix-prefetch-url "https://github.com/urbit/vere/releases/download/vere-v${VERSION}/$1.tgz"
}

LINUX_AARCH64_SHA256=$(prefetch "linux-aarch64")
LINUX_X64_SHA256=$(prefetch "linux-x86_64")
DARWIN_AARCH64_SHA256=$(prefetch "macos-aarch64")
DARWIN_X64_SHA256=$(prefetch "macos-x86_64")

sed -i "s/version = \".*\"/version = \"$VERSION\"/" "$NIX_DRV"

replace-sha256() {
  local platform=$1
  local sha256=$2
  sed -i "s#${platform} = \"[^\"]*\"#${platform} = \"${sha256}\"#" "$NIX_DRV"
}

replace-sha256 "aarch64-linux" "$LINUX_AARCH64_SHA256"
replace-sha256 "x86_64-linux" "$LINUX_X64_SHA256"
replace-sha256 "aarch64-darwin" "$DARWIN_AARCH64_SHA256"
replace-sha256 "x86_64-darwin" "$DARWIN_X64_SHA256"
