#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused nix-prefetch common-updater-scripts node2nix jq
set -euo pipefail

root="$(dirname "$(readlink -f "$0")")"
driver_file="$root/../../web/playwright/driver.nix"
playwright_test="$root/../../web/playwright-test"

version=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} -s https://api.github.com/repos/microsoft/playwright-python/releases/latest | jq -r '.tag_name | sub("^v"; "")')

# Most of the time, this should be the latest stable release of the Node-based
# Playwright version, but that isn't a guarantee, so this needs to be specified
# as well:
setup_py_url="https://github.com/microsoft/playwright-python/raw/v${version}/setup.py"
driver_version=$(curl -Ls "$setup_py_url" | grep '^driver_version =' | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+')

fetch_driver_arch() {
  nix-prefetch-url "https://playwright.azureedge.net/builds/driver/playwright-${driver_version}-${1}.zip"
}

replace_sha() {
  sed -i "s|$1 = \".\{44,52\}\"|$1 = \"$2\"|" "$driver_file"
}

# Replace SHAs for the driver downloads
replace_sha "x86_64-linux" "$(fetch_driver_arch "linux")"
replace_sha "x86_64-darwin" "$(fetch_driver_arch "mac")"
replace_sha "aarch64-linux" "$(fetch_driver_arch "linux-arm64")"
replace_sha "aarch64-darwin" "$(fetch_driver_arch "mac-arm64")"

# Update the version stamps
sed -i "s/version =\s*\"[^\$]*\"/version = \"$driver_version\"/" "$driver_file"
sed -i "s/\"@playwright\/test\": \"[^\$]*\"/\"@playwright\/test\": \"$driver_version\"/" "$playwright_test/node-packages.json"
(cd "$playwright_test"; node2nix -i node-packages.json)
update-source-version playwright "$version" --rev="v$version"
