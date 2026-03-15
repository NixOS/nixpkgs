#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash common-updater-scripts curl gawk jq nix-prefetch-git

set -exuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_NIX="$SCRIPT_DIR/zen-browser.nix"

setKey () {
  sed -i "s|$1 = \".*\"|$1 = \"${2:-}\"|" "${SRC_NIX}"
}

latestVersion=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} "https://api.github.com/repos/zen-browser/desktop/releases/latest" | jq -r .tag_name)
currentVersion=$(nix eval --raw -f . zen-browser-unwrapped.version)

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
   echo "package is up-to-date"
   exit 0
fi

# Retrieving firefox version
currentFirefoxVersion=$(nix eval --raw -f . zen-browser-unwrapped.zen-browser-src.firefox-version)

prefetchOut=$(mktemp)
nix-prefetch-git "https://github.com/zen-browser/desktop.git" --quiet --rev $latestVersion > $prefetchOut
srcDir=$(jq -r .path < $prefetchOut)
srcHash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 $(jq -r .sha256 < $prefetchOut))
firefoxVersion=$(cat $srcDir/surfer.json | jq -r .version.version)
echo "firefox version: $firefoxVersion"

# Retrieving firefox source hash
HOME=$(mktemp -d)
export GNUPGHOME=$(mktemp -d)
gpg --receive-keys 14F26682D0916CDD81E37B6D61B7B526D98F0353

mozillaUrl=https://archive.mozilla.org/pub/firefox/releases/

curl --silent --show-error -o "$HOME"/shasums "$mozillaUrl$firefoxVersion/SHA512SUMS"
curl --silent --show-error -o "$HOME"/shasums.asc "$mozillaUrl$firefoxVersion/SHA512SUMS.asc"
gpgv --keyring="$GNUPGHOME"/pubring.kbx "$HOME"/shasums.asc "$HOME"/shasums

firefoxHash=$(nix --extra-experimental-features nix-command hash convert --from base16 --to sri --hash-algo sha512 $(grep '\.source\.tar\.xz$' "$HOME"/shasums | grep '^[^ ]*' -o))
echo "firefoxHash=$firefoxHash"

# Updating the firefox and zen source hash and version
awk -v currentFirefoxVersion="$currentFirefoxVersion" -v firefoxVersion="$firefoxVersion" -v firefoxHash="$firefoxHash" \
    -v currentZenVersion="$currentVersion" -v zenVersion="$latestVersion" -v srcHash="$srcHash" '
  /firefox-version = "/ { gsub(currentFirefoxVersion, firefoxVersion) }
  /hash = "sha512-/ { gsub(/sha512-[^"]*/, firefoxHash)}
  /zen-version = "/ { gsub(currentZenVersion, zenVersion) }
  /hash = "sha256-/ { gsub(/sha256-[^"]*/, srcHash)}
  { print }
' "$SRC_NIX" > "$SRC_NIX.tmp" && mv "$SRC_NIX.tmp" "$SRC_NIX"

# Update surfer.json
cat $srcDir/surfer.json > $SCRIPT_DIR/surfer.json

# Update ffprefs
setKey cargoHash "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="

set +e
cargoSha256=$(nix build .#zen-browser-unwrapped.passthru.ffprefs 2>&1 >/dev/null | grep "got:" | cut -d':' -f2 | sed 's| ||g')
cargoHash=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri "$cargoSha256")
set -e

if [ -n "${cargoHash:-}" ]; then
    setKey cargoHash "${cargoHash}"
else
    echo "Update failed. cargo_hash is empty."
    exit 1
fi
