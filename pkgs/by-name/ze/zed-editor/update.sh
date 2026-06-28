#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix-update

set -euo pipefail

exec nix-update zed-editor \
  --version-regex '^v(?!.*(?:-pre|0\.999999\.0|0\.9999-temporary)$)(.+)$' \
  --use-github-releases
