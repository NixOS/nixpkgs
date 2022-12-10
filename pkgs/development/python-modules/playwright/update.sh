#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused nix-prefetch common-updater-scripts
set -euo pipefail

root="$(dirname "$(readlink -f "$0")")"

version=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} -s https://api.github.com/repos/microsoft/playwright-python/releases/latest | jq -r '.tag_name | sub("^v"; "")')

# Most of the time, this should be the latest stable release of the Node-based
# Playwright version, but that isn't a guarantee, so this needs to be specified
# as well:
setup_py_url="https://github.com/microsoft/playwright-python/raw/v${version}/setup.py"
driver_version=$(curl -Ls "$setup_py_url" | grep '^driver_version =' | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+')

fetch_driver_arch() {
  nix-prefetch-url "https://playwright.azureedge.net/builds/driver/playwright-${version}-${1}.zip"
}

replace_sha() {
  sed -i "s|$1 = \".\{44,52\}\"|$1 = \"$2\"|" "$root/default.nix"
}

# Replace SHAs for the driver downloads
replace_sha "x86_64-linux" "$(fetch_driver_arch "linux")"
replace_sha "x86_64-darwin" "$(fetch_driver_arch "mac")"
replace_sha "aarch64-linux" "$(fetch_driver_arch "linux-arm64")"
replace_sha "aarch64-darwin" "$(fetch_driver_arch "mac-arm64")"

# Update the version stamps
sed -i "s/driverVersion = \"[^\$]*\"/driverVersion = \"$driver_version\"/" "$root/default.nix"
update-source-version playwright "$version" --rev="v$version"
