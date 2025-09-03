#!/usr/bin/env nix-shell
#!nix-shell -I ../../.. -i bash -p common-updater-scripts curl gnused jq moreutils prefetch-yarn-deps

set -xeuo pipefail

version="$(curl https://api.github.com/repos/Eugeny/tabby/releases/latest | jq -r .tag_name | sed 's/^v//')"
update-source-version tabby-terminal "$version"

package_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
src_dir="$(nix-build -A tabby-terminal.src --no-out-link)"
hashes_file="$package_dir/pkg-hashes.json"

for subproject in $(jq -r 'keys[]' "$hashes_file"); do
  hash="$(prefetch-yarn-deps "$src_dir/$subproject/yarn.lock")"
  hash="$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 "$hash")"
  jq ".[\"$subproject\"] |= \"$hash\"" "$hashes_file" | sponge "$hashes_file"
done
