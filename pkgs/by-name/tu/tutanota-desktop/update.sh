#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl jq common-updater-scripts nixVersions.latest

set -euo pipefail

repo="tutao/tutanota"
tagPrefix="tutanota-desktop-release-"

latestTag=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sSf \
  "https://api.github.com/repos/$repo/releases?per_page=100" \
  | jq -r --arg p "$tagPrefix" \
    '[.[] | select(.prerelease == false) | select(.tag_name | startswith($p))] | .[0].tag_name')
version="${latestTag#"$tagPrefix"}"

currentVersion=$(nix-instantiate --eval -E "with import ./. { }; tutanota-desktop.version" | tr -d '"')

echo "tutanota-desktop: current=$currentVersion latest=$version"
if [[ "$version" == "$currentVersion" ]]; then
  echo "tutanota-desktop: already up to date"
  exit 0
fi

base="https://github.com/$repo/releases/download/$tagPrefix$version"

linuxHash=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri \
  "$(nix-prefetch-url "$base/tutanota-desktop-linux.AppImage")")
update-source-version tutanota-desktop "$version" "$linuxHash" --system=x86_64-linux --ignore-same-version

darwinHash=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri \
  "$(nix-prefetch-url "$base/tutanota-desktop-mac.dmg")")
update-source-version tutanota-desktop "$version" "$darwinHash" --system=aarch64-darwin --ignore-same-version
