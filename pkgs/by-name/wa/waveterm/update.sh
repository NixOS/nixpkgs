#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl coreutils jq common-updater-scripts

latestTag=$(curl https://api.github.com/repos/wavetermdev/waveterm/releases/latest | jq -r ".tag_name")
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
    "aarch64-linux waveterm-linux-arm64" \
    "x86_64-darwin Wave-darwin-universal" \
    "aarch64-darwin Wave-darwin-arm64"; do
    set -- $i
    prefetch=$(nix-prefetch-url "https://github.com/wavetermdev/waveterm/releases/download/v$latestVersion/$2-$latestVersion.zip")
    hash=$(nix-hash --type sha256 --to-sri $prefetch)

    update-source-version waveterm $latestVersion $hash --system=$1 --ignore-same-version
done
