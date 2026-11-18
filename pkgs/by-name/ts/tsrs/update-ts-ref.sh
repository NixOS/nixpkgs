#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts

set -euo pipefail

commit=$(nix-instantiate --eval --raw -E '
  (builtins.fromTOML (builtins.readFile "${(import ./. { }).tsrs.src}/Cargo.toml"))
    .workspace.metadata.typescript.commit
')

if [[ $commit == $(nix-instantiate --eval --raw -A tsrs.tsRef.rev) ]]; then
  exit 0
fi

update-source-version tsrs --ignore-same-version --source-key=tsRef --rev="$commit"
