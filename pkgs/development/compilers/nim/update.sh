#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix-update curl coreutils jq

set -ex

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

curl_github() {
  curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} "$@"
}


case "$UPDATE_NIX_ATTR_PATH" in
nim)
  latestTag=$(curl_github https://api.github.com/repos/nim-lang/Nim/releases/latest | jq -r ".tag_name")
  latestVersion="$(expr "$latestTag" : 'v\(.*\)')"

  echo "Updating Nim"
  nix-update --version "$latestVersion" \
    --override-filename "$SCRIPT_DIR/default.nix" \
  nim
*)
  echo "Unknown attr path $UPDATE_NIX_ATTR_PATH"
  ;;
esac
