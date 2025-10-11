#!/usr/bin/env nix-shell
#!nix-shell -i bash -p cacert curl jq nix moreutils --pure
#shellcheck shell=bash
set -eu -o pipefail

cd "$(dirname "$0")"
nixpkgs=../../../../.

err() {
    echo "$*" >&2
    exit 1
}

json_get() {
    jq -r "$1" < "./versions.json"
}

json_set() {
    jq --arg x "$2" "$1 = \$x" < "./versions.json" | sponge "./versions.json"
}

# Get the latest preview version by trying known patterns
get_latest_preview_version() {
    # Try the most likely current preview versions (in descending order)
    local test_versions=(
        "0.2025.10.01.08.12.preview_03"
        "0.2025.10.01.08.12.preview_02"
        "0.2025.10.01.08.12.preview_01"
        "0.2025.09.24.08.13.preview_03"  # Fallback known version
    )
    for version in "${test_versions[@]}"; do
        local url="https://releases.warp.dev/preview/v${version}/warp-terminal-preview-v${version}-1-x86_64.pkg.tar.zst"
        if curl -s -I "$url" | grep -q "HTTP/2 200"; then
            echo "$version"
            return 0
        fi
    done

    # Fallback to known version
    echo "0.2025.09.24.08.13.preview_03"
}

# nix-prefect-url seems to be uncompressing the archive then taking the hash
# so just get the hash from fetchurl
sri_get() {
    local output sri
    output=$(nix-build --expr \
        "with import $nixpkgs {};
         fetchurl {
           url = \"$1\";
         }" 2>&1 || true)
    sri=$(echo "$output" | awk '/^\s+got:\s+/{ print $2 }')
    [[ -z "$sri" ]] && err "$output"
    echo "$sri"
}

version=$(get_latest_preview_version)
echo "Latest preview version: $version"

for sys in darwin linux_x86_64 linux_aarch64; do
    echo ${sys}
    if [[ ${sys} == "darwin" ]]; then
        url="https://releases.warp.dev/preview/v${version}/WarpPreview.dmg"
    else
        arch_name=${sys#linux_}
        url="https://releases.warp.dev/preview/v${version}/warp-terminal-preview-v${version}-1-${arch_name}.pkg.tar.zst"
    fi

    if [[ ${version} != "$(json_get ".${sys}.version")" ]]; then
        echo "Updating ${sys} to ${version}"
        sri=$(sri_get "$url")
        json_set ".${sys}.version" "${version}"
        json_set ".${sys}.hash" "${sri}"
    else
        echo "${sys} already at latest version ${version}"
    fi
done
