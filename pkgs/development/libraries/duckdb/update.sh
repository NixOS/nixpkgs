#!/usr/bin/env nix-shell
#!nix-shell --pure -i bash -p cacert curl jq moreutils nix-prefetch
# shellcheck shell=bash

set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

nixpkgs=$(while [[ ! -e .git ]]; do [[ ${PWD} != / ]] || exit 1; cd ..; done; echo "${PWD}")

repo=duckdb
owner=duckdb

msg() {
    echo "$*" >&2
}

json_get() {
    jq -r "$1" < 'versions.json'
}

json_set() {
    jq --arg x "$2" "$1 = \$x" < 'versions.json' | sponge 'versions.json'
}

get_latest() {
    curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} -s \
        "https://api.github.com/repos/${owner}/${repo}/releases/latest" | jq -r .tag_name
}

get_sha() {
    curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} -s \
        "https://api.github.com/repos/${owner}/${repo}/git/ref/tags/$1" | jq -r .object.sha
}

tag=$(get_latest)
version=${tag/v/}

[[ ${version} = $(json_get .version) ]] && { msg "${version} is up to date"; exit 0; }

sha=$(get_sha "${tag}")
sri=$(nix-prefetch -I nixpkgs="${nixpkgs}" -E "duckdb.overrideAttrs { version = \"${version}\"; }")

json_set ".version" "${version}"
json_set ".rev" "${sha}"
json_set ".hash" "${sri}"
