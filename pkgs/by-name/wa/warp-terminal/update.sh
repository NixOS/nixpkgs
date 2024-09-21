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

resolve_url() {
    local pkg sfx url
    local -i i max_redirects
    case "$1" in
        darwin)
            pkg=macos
            sfx=dmg
            ;;
        linux_x86_64)
            pkg=pacman
            sfx=pkg.tar.zst
            ;;
        linux_aarch64)
            pkg=pacman_arm64
            sfx=pkg.tar.zst
            ;;
        *)
            err "Unexpected download type: $1"
            ;;
    esac
    url="https://app.warp.dev/download?package=${pkg}"
    ((max_redirects = 15))
    for ((i = 0; i < max_redirects; i++)); do
        url=$(curl -s -o /dev/null -w '%{redirect_url}' "${url}")
        [[ ${url} != *.${sfx} ]] || break
    done
    ((i < max_redirects)) || { err "too many redirects"; }
    echo "${url}"
}

get_version() {
    echo "$1" | grep -oP -m 1 '(?<=/v)[\d.\w]+(?=/)'
}

# nix-prefect-url seems to be uncompressing the archive then taking the hash
# so just get the hash from fetchurl
sri_get() {
    local ouput sri
    output=$(nix-build  --expr \
        "with import $nixpkgs {};
         fetchurl {
           url = \"$1\";
         }" 2>&1 || true)
    sri=$(echo "$output" | awk '/^\s+got:\s+/{ print $2 }')
    [[ -z "$sri" ]] && err "$output"
    echo "$sri"
}


for sys in darwin linux_x86_64 linux_aarch64; do
    echo ${sys}
    url=$(resolve_url ${sys})
    version=$(get_version "${url}")
    if [[ ${version} != "$(json_get ".${sys}.version")" ]]; then
        sri=$(sri_get "${url}")
        json_set ".${sys}.version" "${version}"
        json_set ".${sys}.hash" "${sri}"
    fi
done
