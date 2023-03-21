#!/usr/bin/env nix-shell
#! nix-shell -i oil -p jq sd nix-prefetch-github ripgrep

# TODO set to `verbose` or `extdebug` once implemented in oil
set -x

const directory = $(dirname $0 | xargs realpath)
const owner = "elixir-lsp"
const repo = "elixir-ls"
const latest_rev = $(curl -q https://api.github.com/repos/${owner}/${repo}/releases/latest | \
  jq -r '.tag_name')
const latest_version = $(echo $latest_rev | sd 'v' '')
const current_version = $(jq -r '.version' $directory/pin.json)
if ("$latest_version" === "$current_version") {
  echo "elixir-ls is already up-to-date"
  return 0
} else {
  const tarball_meta = $(nix-prefetch-github $owner $repo --rev "$latest_rev")
  const tarball_hash = "sha256-$(echo $tarball_meta | jq -r '.sha256')"
  const sha256s = $(rg '"sha256-.+"' $directory/default.nix | sd '.+"(.+)";' '$1' )

  jq ".version = \"$latest_version\" | \
      .\"sha256\" = \"$tarball_hash\" | \
      .\"depsSha256\" = \"\"" $directory/pin.json | sponge $directory/pin.json

  const new_mix_hash = $(nix-build -A elixir-ls.mixFodDeps 2>&1 | \
    tail -n 1 | \
    sd '\s+got:\s+' '')

  jq ".depsSha256 = \"$new_mix_hash\"" $directory/pin.json | sponge $directory/pin.json
}
