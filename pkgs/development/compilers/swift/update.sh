#!/usr/bin/env nix-shell
#!nix-shell -i bash -E "with import <nixpkgs> {}; runCommandWith { name = \"shell\"; inherit (swiftPackages) stdenv; derivationArgs = { buildInputs = [ gawk gnused nix-prefetch-github jq swift swiftpm swiftpm2nix ]; }; } \"\""

set -euo pipefail

cd "$(dirname "$0")"

currentVersion="$(gawk -F'"' '/version = ".*"/ { print $2 }' ./sources.nix)"
if [[ -z "$currentVersion" ]]; then
    echo >&2 "Could not determine current Swift version from sources.nix"
    exit 1
fi

latestTag="$(curl https://api.github.com/repos/apple/swift/releases/latest | jq -r '.tag_name')"
latestVersion="$(expr $latestTag : 'swift-\(.*\)-RELEASE')"
if [[ -z "$latestVersion" ]]; then
    echo >&2 "Could not determine latest Swift version from GitHub releases"
    exit 1
fi

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo >&2 "Swift is up-to-date: ${currentVersion}"
    exit 0
fi

echo >&2 "Updating Swift: $currentVersion -> $latestVersion"

# Update sources.nix

for repo in $(gawk '/sha256/ { print $1 }' ./sources.nix); do
    echo >&2 "Prefetching $repo..."
    sriHash="$(nix-prefetch-github --rev "$latestTag" apple "$repo" | jq -r .hash)"
    if [[ -z "$sriHash" ]]; then
        echo >&2 "Could not determine hash of apple/$repo tag $latestTag"
        exit 1
    fi

    sed -i "s|$repo = \".*\"|$repo = \"$sriHash\"|" ./sources.nix
done

sed -i "s|version = \".*\"|version = \"$latestVersion\"|" ./sources.nix

# Update swiftpm2nix generated expressions

work="$(mktemp -d)"
clean_up() {
  rm -rf "$work"
}
trap clean_up EXIT

for generated in */generated; do
    package="$(dirname "$generated")"
    src="$(nix build --no-link --print-out-paths -f ../../../.. "swiftPackages.$package.src")"

    cp -R "$src" "$work/$package"
    chmod -R u+w "$work"
    pushd "$work/$package" > /dev/null

    echo >&2 "Running swiftpm on $package"
    swift package resolve

    echo >&2 "Running swiftpm2nix on $package"
    swiftpm2nix

    popd > /dev/null
    rm -fr "$generated"
    cp -R "$work/$package/nix" "$generated"
done
