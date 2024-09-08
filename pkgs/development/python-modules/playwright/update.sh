#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused common-updater-scripts jq prefetch-npm-deps
set -euo pipefail

root="$(dirname "$(readlink -f "$0")")"

version=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} -s https://api.github.com/repos/microsoft/playwright-python/releases/latest | jq -r '.tag_name | sub("^v"; "")')
# Most of the time, this should be the latest stable release of the Node-based
# Playwright version, but that isn't a guarantee, so this needs to be specified
# as well:
setup_py_url="https://github.com/microsoft/playwright-python/raw/v${version}/setup.py"
driver_version=$(curl -Ls "$setup_py_url" | grep '^driver_version =' | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+')

update-source-version playwright-driver "$driver_version"
update-source-version python3Packages.playwright "$version"

# Update package-lock.json files for all npm deps that are built in playwright
# TODO: skip if update-source-version reported the same version
driver_file="$root/../../web/playwright/driver.nix"
repo_url_prefix="https://github.com/microsoft/playwright/raw"
temp_dir=$(mktemp -d)

trap 'rm -rf "$temp_dir"' EXIT


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
