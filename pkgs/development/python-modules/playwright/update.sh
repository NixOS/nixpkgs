#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused gawk nix-prefetch common-updater-scripts

set -euo pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
NIX_DRV="$ROOT/driver.nix"
if [ ! -f "$NIX_DRV" ]; then
  echo "ERROR: cannot find driver.nix in $ROOT"
  exit 1
fi

fetch_arch() {
  VER="$1"; ARCH="$2"
  URL="https://playwright.azureedge.net/builds/driver/playwright-${VER}-${ARCH}.zip"
  nix-prefetch "{ stdenv, fetchzip }:
stdenv.mkDerivation rec {
  pname = \"playwright-driver\"; version = \"${VER}\";
  src = fetchzip { url = \"$URL\"; postFetch = \"mkdir -p \$out/driver && install \$downloadedFile \$out/driver/playwright-${VER}-${ARCH}.zip\"; };
}
"
}

replace_sha() {
  sed -i "s#$1 = \"sha256-.\{44\}\"#$1 = \"$2\"#" "$NIX_DRV"
}

# https://playwright.azureedge.net/builds/driver/playwright-1.21.0-mac-arm64.zip
PLAYWRIGHT_VER=$(curl -Ls -w "%{url_effective}" -o /dev/null https://github.com/microsoft/playwright-python/releases/latest | awk -F'/' '{print $NF}' | sed 's/v//')

PLAYWRIGHT_LINUX_X64_SHA256=$(fetch_arch "$PLAYWRIGHT_VER" "linux")
PLAYWRIGHT_DARWIN_X64_SHA256=$(fetch_arch "$PLAYWRIGHT_VER" "mac")
PLAYWRIGHT_LINUX_AARCH64_SHA256=$(fetch_arch "$PLAYWRIGHT_VER" "linux-arm64")
PLAYWRIGHT_DARWIN_AARCH64_SHA256=$(fetch_arch "$PLAYWRIGHT_VER" "mac-arm64")

sed -i "s/version = \"[^\$]*\"/version = \"$PLAYWRIGHT_VER\"/" "$ROOT/default.nix"

replace_sha "x86_64-linux" "$PLAYWRIGHT_LINUX_X64_SHA256"
replace_sha "x86_64-darwin" "$PLAYWRIGHT_DARWIN_X64_SHA256"
replace_sha "aarch64-linux" "$PLAYWRIGHT_LINUX_AARCH64_SHA256"
replace_sha "aarch64-darwin" "$PLAYWRIGHT_DARWIN_AARCH64_SHA256"

cd ../../../.. && update-source-version playwright "$PLAYWRIGHT_VER" --file=pkgs/development/python-modules/playwright/default.nix
