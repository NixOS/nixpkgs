#!/usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq git gnused gnugrep

#
# Get latest version of TradingView from Snapcraft.
#

snap_info=($(
  curl -s -H 'X-Ubuntu-Series: 16' \
    'https://api.snapcraft.io/api/v1/snaps/details/tradingview' \
  | jq --raw-output \
    '.revision,.download_sha512,.version,.last_updated'
))

# "revision" is the actual version identifier; "version" is for human consumption.
revision="${snap_info[0]}"
sha512="${snap_info[1]}"
sri=$(nix --extra-experimental-features nix-command hash to-sri --type "sha512" $sha512)
upstream_version="${snap_info[2]}"
last_updated="${snap_info[3]}"

echo "Latest release is $upstream_version from $last_updated."

#
# Read the current TradingView version.
#

nixpkgs="$(git rev-parse --show-toplevel)"
tradingview_nix="$nixpkgs/pkgs/by-name/tr/tradingview/package.nix"
current_nix_version=$(
  grep 'version\s*=' "$tradingview_nix" \
  | sed -Ene 's/.*"(.*)".*/\1/p'
)

echo "Current nix version: $current_nix_version"

if [[ "$current_nix_version" = "$upstream_version" ]]; then
  echo "TradingView is already up-to-date"
  exit 0
fi

#
# Find and replace.
#

echo "Updating from ${current_nix_version} to ${upstream_version}, released ${last_updated}"
echo 's/hash\s*=\s*"[^"]*"\s*;/hash = "'"${sri}"'";/'
sed --regexp-extended \
  -e 's/revision\s*=\s*"[0-9]+"\s*;/revision = "'"${revision}"'";/' \
  -e 's#hash\s*=\s*"[^"]*"\s*;#hash = "'"${sri}"'";#' \
  -e 's/version\s*=\s*".*"\s*;/version = "'"${upstream_version}"'";/' \
  -i "$tradingview_nix"

#
# Attempt a build.
#

export NIXPKGS_ALLOW_UNFREE=1

if ! nix-build -A tradingview "$nixpkgs"; then
  echo "The updated TradingView failed to build."
  exit 1
fi

#
# Commit changes.
#
git add "$tradingview_nix"
git commit -m "tradingview: ${current_nix_version} -> ${upstream_version}"

