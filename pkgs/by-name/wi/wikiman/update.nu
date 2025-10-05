#!/usr/bin/env nix-shell
#!nix-shell -i nu -p nushell common-updater-scripts

# Update wikiman itself
# =====================
print -e "Updating wikiman..."

let current_version = nix-instantiate --eval -E "with import ./. {}; wikiman.version or (lib.getVersion wikiman)"
  | str trim -c '"'

let latest_version = list-git-tags --url=https://github.com/filiparag/wikiman
  | lines
  | sort --natural
  | where ($it =~ '^[\d.]+$')
  | last

if $current_version == $latest_version {
  print -e "Wikiman is up to date!"
  exit 0
}

update-source-version wikiman $latest_version
print -e $"Wikiman has been updated from ($current_version) to ($latest_version)!"

# Update sources
# ==============
# This part is essentially what the upstream Makefile does when building
# sources, except that this solution isn't nearly as cursed. I mean, who
# parses JSON via an awk script that is first compressed with xz, base64-
# encoded and then inlined within the Makefile?
print -e "Updating wikiman sources..."

http get $'https://api.github.com/repos/filiparag/wikiman/releases/tags/($latest_version)'
  | $in.assets
  | where name ends-with '.source.tar.xz'
  | par-each { |source| {
    name: ($source.name | split row '_' | $in.0),
    url: $source.browser_download_url,
    hash: (
      nix store prefetch-file --unpack --json $source.browser_download_url
        | from json
        | get hash
    )
  } }
  # Make it deterministic
  | sort-by name
  | to json
  | save --force $'(pwd)/pkgs/by-name/wi/wikiman/sources.json'
