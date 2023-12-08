#! /usr/bin/env nix-shell
#! nix-shell -i bash -p gnugrep gnused coreutils curl wget jq nix-update prefetch-npm-deps nodejs

# shellcheck shell=bash

set -euo pipefail
pushd "$(dirname "${BASH_SOURCE[0]}")"

version=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} -s "https://api.github.com/repos/freifunkMUC/wg-access-server/tags" | jq -r .[0].name | grep -oP "^v\K.*")
url="https://raw.githubusercontent.com/freifunkMUC/wg-access-server/v$version/"

if [[ "$UPDATE_NIX_OLD_VERSION" == "$version" ]]; then
    echo "Already up to date!"
    exit 0
fi

rm -f package-lock.json
wget "$url/web/package-lock.json"
npm_hash=$(prefetch-npm-deps package-lock.json)
sed -i 's#npmDepsHash = "[^"]*"#npmDepsHash = "'"$npm_hash"'"#' default.nix
trap 'rm -f package-lock.json' EXIT

popd
nix-update wg-access-server --version "$version"
