#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nix-update
set -xeuo pipefail
IFS=$'\n\t'

readarray -t commands < <(
  nix-instantiate --eval --json --strict --arg pkgsPath ./. \
    pkgs/by-name/ze/zellij/plugins/updater/gen-update-commands.nix \
  | jq -r '.[]'
)
for command in "${commands[@]}"; do
  bash -c "$command"
done

sed -i "s/version = .*/version = \"$(date --iso-8601)\";/" pkgs/by-name/ze/zellij/plugins/updater/default.nix
