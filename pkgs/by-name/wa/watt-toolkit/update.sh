#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix curl coreutils jq common-updater-scripts

latestVersion=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/BeyondDimension/SteamTools/releases/latest | jq -r ".tag_name")
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; watt-toolkit.version or (lib.getVersion watt-toolkit)" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

for i in \
    "x86_64-linux x64" \
    "aarch64-linux arm64"; do
    set -- $i
    hash=$(nix hash convert --to sri --hash-algo sha256 $(nix-prefetch-url "https://github.com/BeyondDimension/SteamTools/releases/download/$latestVersion/Steam++_v$latestVersion_linux_$2.tgz"))
    update-source-version watt-toolkit $latestVersion $hash --system=$1 --ignore-same-version
done
