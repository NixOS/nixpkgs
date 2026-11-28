#!/usr/bin/env nix-shell
#! nix-shell -I nixpkgs=./. -i bash -p common-updater-scripts curl gh

set -xeuo pipefail

basedir="$(dirname "$0")/../../../.."

latest_version="$(
  gh release --repo 'werf/werf' list \
    --exclude-pre-releases \
    --limit 1 \
    --json tagName \
    --jq '.[].tagName | ltrimstr("v")'
)"
current_version="$(
  nix-instantiate \
    --eval \
    -E "with import ${basedir} {}; lib.getVersion werf-bin" |
    tr -d '"'
)"

if [[ "$latest_version" == "$current_version" ]]; then
  echo "Package is up-to-date"
  exit 0
fi

declare -A platforms=(
  ["aarch64-darwin"]="darwin-arm64"
  ["aarch64-linux"]="linux-arm64"
  ["x86_64-linux"]="linux-amd64"
)
for k in "${!platforms[@]}"; do
  v="${platforms[$k]}"

  file="$(nix-prefetch-url "https://tuf.werf.io/targets/releases/${latest_version}/${v}/bin/werf" 2>/dev/null)"
  hash="$(nix-hash --type sha256 --to-sri "$file")"
  cd "$basedir"
  update-source-version werf-bin "$latest_version" "$hash" \
    --system="$k" \
    --ignore-same-version
done
