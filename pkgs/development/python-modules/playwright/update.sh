#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused gawk nix-prefetch common-updater-scripts

set -euo pipefail

# This is the target version of playwright-python we want to update to. Find out
# what's the current one here:
# https://pypi.org/project/playwright/
TARGET_VERSION="1.25.1"

# The driver version required for the specific Playwright version we have is
# hard-coded here:
# https://github.com/microsoft/playwright-python/blob/v1.25.1/setup.py#L33
# Most of the time, this should be the latest stable release of the Node-based
# Playwright version, but that isn't a guarantee, so this needs to be specified
# as well:
DRIVER_VERSION="1.25.0"


ROOT="$(dirname "$(readlink -f "$0")")"
NIX_FILE="$ROOT/default.nix"

fetch_driver_arch() {
  VERSION="$1"
  ARCH="$2"
  nix-prefetch-url "https://playwright.azureedge.net/builds/driver/playwright-${VERSION}-${ARCH}.zip"
}

replace_sha() {
  sed -i "s#$1 = \"sha256-.\{44\}\"#$1 = \"$2\"#" "$NIX_FILE"
}

# Replace SHAs for the driver downloads.
replace_sha "x86_64-linux" "$(fetch_driver_arch "$DRIVER_VERSION" "linux")"
replace_sha "x86_64-darwin" "$(fetch_driver_arch "$DRIVER_VERSION" "mac")"
replace_sha "aarch64-linux" "$(fetch_driver_arch "$DRIVER_VERSION" "linux-arm64")"
replace_sha "aarch64-darwin" "$(fetch_driver_arch "$DRIVER_VERSION" "mac-arm64")"

# Update the version stamps.
sed -i "s/driverVersion = \"[^\$]*\"/driverVersion = \"$DRIVER_VERSION\"/" "$NIX_FILE"
update-source-version playwright "$TARGET_VERSION" --rev="v$TARGET_VERSION"
