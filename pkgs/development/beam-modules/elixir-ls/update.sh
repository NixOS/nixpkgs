#!/usr/bin/env nix-shell
#! nix-shell -i oil -p jq sd nix-prefetch-github ripgrep
# shellcheck shell=bash

# TODO set to `verbose` or `extdebug` once implemented in oil
shopt --set xtrace

var directory = $(dirname $0 | xargs realpath)
var owner = "elixir-lsp"
var repo = "elixir-ls"
var latest_rev = $(curl -q https://api.github.com/repos/${owner}/${repo}/releases/latest | \
  jq -r '.tag_name')
var latest_version = $(echo $latest_rev | sd 'v' '')
var current_version = $(nix-instantiate -A elixir_ls.version --eval --json | jq -r)
if ("$latest_version" == "$current_version") {
  echo "elixir-ls is already up-to-date"
  return 0
} else {
  var tarball_meta = $(nix-prefetch-github $owner $repo --rev "$latest_rev")
  var tarball_hash = "sha256-$(echo $tarball_meta | jq -r '.sha256')"
  var sha256s = $(rg '"sha256-.+"' $directory/default.nix | sd '.+"(.+)";' '$1' )
  echo $sha256s | read --line :github_sha256
  echo $sha256s | tail -n 1 | read --line :old_mix_sha256
  sd 'version = ".+"' "version = \"$latest_version\"" "$directory/default.nix"
  sd "sha256 = \"$github_sha256\"" "sha256 = \"$tarball_hash\"" "$directory/default.nix"
  sd "sha256 = \"$old_mix_sha256\"" "sha256 = \"\"" "$directory/default.nix"

  var new_mix_hash = $(nix-build -A elixir_ls.mixFodDeps 2>&1 | \
    tail -n 1 | \
    sd '\s+got:\s+' '')

  sd "sha256 = \"\"" "sha256 = \"$new_mix_hash\"" "$directory/default.nix"
}
