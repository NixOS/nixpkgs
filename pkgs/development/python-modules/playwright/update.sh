#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused common-updater-scripts jq prefetch-npm-deps unzip nix-prefetch
set -euo pipefail

root="$(dirname "$(readlink -f "$0")")"

version=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} -s https://api.github.com/repos/microsoft/playwright-python/releases/latest | jq -r '.tag_name | sub("^v"; "")')
# Most of the time, this should be the latest stable release of the Node-based
# Playwright version, but that isn't a guarantee, so this needs to be specified
# as well:
setup_py_url="https://github.com/microsoft/playwright-python/raw/v${version}/setup.py"
driver_version=$(curl -Ls "$setup_py_url" | grep '^driver_version =' | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+')

# TODO: skip if update-source-version reported the same version
update-source-version playwright-driver "$driver_version"
update-source-version python3Packages.playwright "$version"

playwright_dir="$root/../../web/playwright"
driver_file="$playwright_dir/driver.nix"
repo_url_prefix="https://github.com/microsoft/playwright/raw"

temp_dir=$(mktemp -d)
trap 'rm -rf "$temp_dir"' EXIT

# Update playwright-mcp package
mcp_version=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} -s https://api.github.com/repos/microsoft/playwright-mcp/releases/latest | jq -r '.tag_name | sub("^v"; "")')
update-source-version playwright-mcp "$mcp_version"

# Update npmDepsHash for playwright-mcp
pushd "$temp_dir" >/dev/null
curl -fsSL -o package-lock.json "https://raw.githubusercontent.com/microsoft/playwright-mcp/v${mcp_version}/package-lock.json"
mcp_npm_hash=$(prefetch-npm-deps package-lock.json)
rm -f package-lock.json
popd >/dev/null

mcp_package_file="$root/../../../by-name/pl/playwright-mcp/package.nix"
sed -E 's#\bnpmDepsHash = ".*?"#npmDepsHash = "'"$mcp_npm_hash"'"#' -i "$mcp_package_file"


# update binaries of browsers, used by playwright.
replace_sha() {
  sed -i "s|$2 = \".\{44,52\}\"|$2 = \"$3\"|" "$1"
}

prefetch_browser() {
  # nix-prefetch is used to obtain sha with `stripRoot = false`
  # doesn't work on macOS https://github.com/msteen/nix-prefetch/issues/53
  nix-prefetch --option extra-experimental-features flakes -q "{ stdenv, fetchzip }: stdenv.mkDerivation { name=\"browser\"; src = fetchzip { url = \"$1\"; stripRoot = $2; }; }"
}

update_browser() {
    name="$1"
    platform="$2"
    stripRoot="false"
    if [ "$platform" = "darwin" ]; then
        if [ "$name" = "webkit" ]; then
            suffix="mac-14"
        else
            suffix="mac"
        fi
    else
        if [ "$name" = "ffmpeg" ] || [ "$name" = "chromium-headless-shell" ]; then
            suffix="linux"
        elif [ "$name" = "chromium" ]; then
            stripRoot="true"
            suffix="linux"
        elif [ "$name" = "firefox" ]; then
            stripRoot="true"
            suffix="ubuntu-22.04"
        else
            suffix="ubuntu-22.04"
        fi
    fi
    aarch64_suffix="$suffix-arm64"
    if [ "$name" = "chromium-headless-shell" ]; then
        buildname="chromium";
    else
        buildname="$name"
    fi

    revision="$(jq -r ".browsers[\"$buildname\"].revision" "$playwright_dir/browsers.json")"
    replace_sha "$playwright_dir/$name.nix" "x86_64-$platform" \
        "$(prefetch_browser "https://playwright.azureedge.net/builds/$buildname/$revision/$name-$suffix.zip" $stripRoot)"
    replace_sha "$playwright_dir/$name.nix" "aarch64-$platform" \
        "$(prefetch_browser "https://playwright.azureedge.net/builds/$buildname/$revision/$name-$aarch64_suffix.zip" $stripRoot)"
}

curl -fsSl \
    "https://raw.githubusercontent.com/microsoft/playwright/v${driver_version}/packages/playwright-core/browsers.json" \
    | jq '
      .comment = "This file is kept up to date via update.sh"
      | .browsers |= (
        [.[]
          | select(.installByDefault) | del(.installByDefault)]
          | map({(.name): . | del(.name)})
          | add
      )
    ' > "$playwright_dir/browsers.json"

update_browser "chromium" "linux"
update_browser "chromium-headless-shell" "linux"
update_browser "firefox" "linux"
update_browser "webkit" "linux"
update_browser "ffmpeg" "linux"

update_browser "chromium" "darwin"
update_browser "chromium-headless-shell" "darwin"
update_browser "firefox" "darwin"
update_browser "webkit" "darwin"
update_browser "ffmpeg" "darwin"

# Update package-lock.json files for all npm deps that are built in playwright

# Function to download `package-lock.json` for a given source path and update hash
update_hash() {
    local source_root_path="$1"
    local existing_hash="$2"

    # Formulate download URL
    local download_url="${repo_url_prefix}/v${driver_version}${source_root_path}/package-lock.json"
    # Download package-lock.json to temporary directory
    curl -fsSL -o "${temp_dir}/package-lock.json" "$download_url"

    # Calculate the new hash
    local new_hash
    new_hash=$(prefetch-npm-deps "${temp_dir}/package-lock.json")

    # Update npmDepsHash in the original file
    sed -i "s|$existing_hash|${new_hash}|" "$driver_file"
}

while IFS= read -r source_root_line; do
    [[ "$source_root_line" =~ sourceRoot ]] || continue
    source_root_path=$(echo "$source_root_line" | sed -e 's/^.*"${src.name}\(.*\)";.*$/\1/')
    # Extract the current npmDepsHash for this sourceRoot
    existing_hash=$(grep -A1 "$source_root_line" "$driver_file" | grep 'npmDepsHash' | sed -e 's/^.*npmDepsHash = "\(.*\)";$/\1/')

    # Call the function to download and update the hash
    update_hash "$source_root_path" "$existing_hash"
done < "$driver_file"
