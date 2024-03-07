#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq moreutils nix-prefetch
#shellcheck shell=bash
set -eu -o pipefail

dirname="$(dirname "$0")"

err() {
    echo "$*" >&2
}

json_get() {
    jq -r "$1" < "$dirname/versions.json"
}

json_set() {
    jq --arg x "$2" "$1 = \$x" < "$dirname/versions.json" | sponge "$dirname/versions.json"
}

resolve_url() {
    local pkg sfx url
    local -i i max_redirects
    case "$1" in
        darwin)
            pkg=macos
            sfx=dmg
            ;;
        linux)
            pkg=pacman
            sfx=pkg.tar.zst
            ;;
        *)
            err "Unexpected download type: $1"
            exit 1
            ;;
    esac
    url="https://app.warp.dev/download?package=${pkg}"
    ((max_redirects = 15))
    for ((i = 0; i < max_redirects; i++)); do
        url=$(curl -s -o /dev/null -w '%{redirect_url}' "${url}")
        [[ ${url} != *.${sfx} ]] || break
    done
    ((i < max_redirects)) || { err "too many redirects"; exit 1; }
    echo "${url}"
}

get_version() {
    echo "$1" | grep -oP -m 1 '(?<=/v)[\d.\w]+(?=/)'
}

for sys in darwin linux; do
    url=$(resolve_url ${sys})
    version=$(get_version "${url}")
    if [[ ${version} != "$(json_get ".${sys}.version")" ]];
        then
            sri=$(nix hash to-sri --type sha256 "$(nix-prefetch-url --type sha256 "${url}")")
            json_set ".${sys}.version" "${version}"
            json_set ".${sys}.hash" "${sri}"
    fi
done
