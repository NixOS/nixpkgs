#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix common-updater-scripts

set -euo pipefail

version="$(
  curl -fsSL ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "https://api.github.com/repos/Loyalsoldier/v2ray-rules-dat/releases/latest" \
    | jq -r .tag_name
)"

if [[ "$UPDATE_NIX_OLD_VERSION" == "$version" ]]; then
  echo "Already up to date!"
  exit 0
fi

prefetch_hash() {
  local name="$1"
  nix --extra-experimental-features nix-command \
    store prefetch-file \
    --json \
    --hash-type sha256 \
    "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/$version/$name" \
    | jq -r .hash
}

geoip_hash="$(prefetch_hash geoip.dat)"
geosite_hash="$(prefetch_hash geosite.dat)"

update-source-version "v2ray-rules-dat" "$version" "$geoip_hash" \
  --source-key=passthru.geoipDat \
  --ignore-same-version --ignore-same-hash

update-source-version "v2ray-rules-dat" "$version" "$geosite_hash" \
  --source-key=passthru.geositeDat \
  --ignore-same-version --ignore-same-hash
