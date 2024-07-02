#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused nix-prefetch common-updater-scripts node2nix jq unzip
set -euo pipefail

root="$(dirname "$(readlink -f "$0")")"
playwright_dir="$root/../../web/playwright"
driver_file="$playwright_dir/driver.nix"
playwright_test="$root/../../web/playwright-test"

version=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} -s https://api.github.com/repos/microsoft/playwright-python/releases/latest | jq -r '.tag_name | sub("^v"; "")')

# Most of the time, this should be the latest stable release of the Node-based
# Playwright version, but that isn't a guarantee, so this needs to be specified
# as well:
setup_py_url="https://github.com/microsoft/playwright-python/raw/v${version}/setup.py"
driver_version=$(curl -Ls "$setup_py_url" | grep '^driver_version =' | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+')

fetch_driver_arch() {
  nix-prefetch-url --print-path "https://playwright.azureedge.net/builds/driver/playwright-${driver_version}-${1}.zip"
}

replace_sha() {
  sed -i "s|$2 = \".\{44,52\}\"|$2 = \"$3\"|" "$1"
}

linux_driver="$(fetch_driver_arch "linux")"
linux_driver_hash="$(echo "$linux_driver" | head -1)"
linux_driver_path="$(echo "$linux_driver" | tail -1)"
# browsers.json is expected to include data for all platforms
unzip -p "$linux_driver_path" package/browsers.json \
    | jq '
        .comment = "This file is kept up to date via update.sh"
        | .browsers |= (
            [.[]
                | select(.installByDefault) | del(.installByDefault)]
                | map({(.name): . | del(.name)})
                |add
        )
    ' \
    > "$playwright_dir/browsers.json"

# Replace SHAs for the driver downloads
replace_sha "$driver_file" "x86_64-linux" "$linux_driver_hash"
replace_sha "$driver_file" "x86_64-darwin" "$(fetch_driver_arch "mac" | head -1)"
replace_sha "$driver_file" "aarch64-linux" "$(fetch_driver_arch "linux-arm64" | head -1)"
replace_sha "$driver_file" "aarch64-darwin" "$(fetch_driver_arch "mac-arm64" | head -1)"

update_browser() {
    name="$1"
    suffix="$2"
    arm64_suffix="${3:-$2-arm64}"
    revision="$(jq -r ".browsers.$name.revision" "$playwright_dir/browsers.json")"
    replace_sha "$playwright_dir/$name.nix" "x86_64-linux" \
        "$(nix-prefetch-url --unpack "https://playwright.azureedge.net/builds/$name/$revision/$name-$suffix.zip")"
    replace_sha "$playwright_dir/$name.nix" "aarch64-linux" \
        "$(nix-prefetch-url --unpack "https://playwright.azureedge.net/builds/$name/$revision/$name-$arm64_suffix.zip")"
}

# We currently use Chromium from nixpkgs, so we don't need to download it here
# Likewise, darwin can be ignored here atm as we are using an impure install anyway.
update_browser "firefox" "ubuntu-22.04"
update_browser "webkit" "ubuntu-22.04"
update_browser "ffmpeg" "linux"

# Update the version stamps
sed -i "s/version =\s*\"[^\$]*\"/version = \"$driver_version\"/" "$driver_file"
sed -i "s/\"@playwright\/test\": \"[^\$]*\"/\"@playwright\/test\": \"$driver_version\"/" "$playwright_test/node-packages.json"
(cd "$playwright_test"; node2nix -i node-packages.json)
update-source-version playwright "$version" --rev="v$version"
