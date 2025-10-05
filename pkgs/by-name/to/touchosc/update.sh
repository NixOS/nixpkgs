#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix curl libxml2 jq

set -euo pipefail

nixpkgs="$(git rev-parse --show-toplevel || (printf 'Could not find root of nixpkgs repo\nAre we running from within the nixpkgs git repo?\n' >&2; exit 1))"

attr="${UPDATE_NIX_ATTR_PATH:-touchosc}"
version="$(curl -sSL https://hexler.net/touchosc/appcast/linux | xmllint --xpath '/rss/channel/item/enclosure/@*[local-name()="version"]' - | cut -d= -f2- | tr -d '"' | head -n1)"

narhash() {
    nix --extra-experimental-features nix-command store prefetch-file --json "$url" | jq -r .hash
}

nixeval() {
    if [ "$#" -ge 2 ]; then
        systemargs=(--argstr system "$2")
    else
        systemargs=()
    fi

    nix --extra-experimental-features nix-command eval --json --impure "${systemargs[@]}" -f "$nixpkgs" "$1" | jq -r .
}

findpath() {
    path="$(nix --extra-experimental-features nix-command eval --json --impure -f "$nixpkgs" "$1.meta.position" | jq -r . | cut -d: -f1)"
    outpath="$(nix --extra-experimental-features nix-command eval --json --impure --expr "fetchGit \"$nixpkgs\"")"

    if [ -n "$outpath" ]; then
        path="${path/$(echo "$outpath" | jq -r .)/$nixpkgs}"
    fi

    echo "$path"
}

oldversion="${UPDATE_NIX_OLD_VERSION:-$(nixeval "$attr".version)}"

pkgpath="$(findpath "$attr")"

if [ "$version" = "$oldversion" ]; then
    echo 'update.sh: New version same as old version, nothing to do.'
    exit 0
fi

sed -i -e "/version\s*=/ s|\"$oldversion\"|\"$version\"|" "$pkgpath"

for system in aarch64-linux armv7l-linux x86_64-linux; do
    url="$(nixeval "$attr".src.url "$system")"

    curhash="$(nixeval "$attr".src.outputHash "$system")"
    newhash="$(narhash "$url")"

    sed -i -e "s|\"$curhash\"|\"$newhash\"|" "$pkgpath"
done
