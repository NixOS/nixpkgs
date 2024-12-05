#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nixVersions.latest curl coreutils jq common-updater-scripts

set -eou pipefail

latestTag=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/wavetermdev/waveterm/releases/latest | jq -r ".tag_name")
latestVersion="$(expr "$latestTag" : 'v\(.*\)')"
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; waveterm.version" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

for i in \
    "x86_64-linux waveterm-linux-x64" \
    "aarch64-linux waveterm-linux-arm64"; do
    set -- $i
    prefetch=$(nix-prefetch-url --unpack "https://github.com/wavetermdev/waveterm/releases/download/v$latestVersion/$2-$latestVersion.zip")
    hash=$(nix hash convert --hash-algo sha256 --to sri $prefetch)
    update-source-version waveterm $latestVersion $hash --system=$1 --ignore-same-version
done

for i in \
    "x86_64-darwin Wave-darwin-x64" \
    "aarch64-darwin Wave-darwin-arm64"; do
    set -- $i
    prefetch=$(nix-prefetch-url "https://github.com/wavetermdev/waveterm/releases/download/v$latestVersion/$2-$latestVersion.zip")
    hash=$(nix hash convert --hash-algo sha256 --to sri $prefetch)
    update-source-version waveterm $latestVersion $hash --system=$1 --ignore-same-version
done
