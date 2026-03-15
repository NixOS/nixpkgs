#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update common-updater-scripts curl jq

# Update all leanPackages to match the lean4 version in nixpkgs.
#
# All mathlib-ecosystem packages (batteries, aesop, Qq, plausible,
# importGraph, Cli, mathlib) release with the same version tag as
# lean4 (lockstep versioning).  ProofWidgets and LeanSearchClient
# have their own versioning; the correct versions are read from
# mathlib's lake-manifest.json at the matching lean4 tag.
#
# This script only prefetches source hashes — it does not build
# anything.  Output is a summary suitable for commit messages.
#
# Usage:
#   ./pkgs/development/lean-modules/update.sh

set -euo pipefail

lean4_version=$(nix eval --raw .#lean4.version)

# Snapshot current versions for diffing.
old_lockstep=$(nix eval --raw .#leanPackages.mathlib.version 2>/dev/null || echo "")
old_pw=$(nix eval --raw .#leanPackages.proofwidgets.version 2>/dev/null || echo "")
old_lsc=$(nix eval --raw .#leanPackages.LeanSearchClient.version 2>/dev/null || echo "")

manifest=$(curl -sL "https://raw.githubusercontent.com/leanprover-community/mathlib4/v${lean4_version}/lake-manifest.json")

# Verify that mathlib's dependency set matches what we package.
# If mathlib adds or removes a dep, this script needs manual updating.
known_deps="Cli LeanSearchClient Qq aesop batteries importGraph plausible proofwidgets"
manifest_deps=$(echo "$manifest" | jq -r '[.packages[].name] | sort | join(" ")')
if [ "$manifest_deps" != "$known_deps" ]; then
  echo "ERROR: mathlib dependency set has changed" >&2
  echo "  expected: $known_deps" >&2
  echo "  got:      $manifest_deps" >&2
  exit 1
fi

pw_version=$(echo "$manifest" | jq -r '.packages[] | select(.name == "proofwidgets") | .inputRev' | sed 's/^v//')

lsc_rev=$(echo "$manifest" | jq -r '.packages[] | select(.name == "LeanSearchClient") | .rev')
lsc_date=$(curl -sL "https://api.github.com/repos/leanprover-community/LeanSearchClient/commits/$lsc_rev" | jq -r '.commit.committer.date[:10]')
lsc_version="0-unstable-$lsc_date"

# Leaf packages (no leanDeps).
nix-update leanPackages.batteries        --version="$lean4_version"
nix-update leanPackages.Qq               --version="$lean4_version"
nix-update leanPackages.plausible        --version="$lean4_version"
nix-update leanPackages.Cli              --version="$lean4_version"
nix-update leanPackages.proofwidgets     --version="$pw_version"

# LeanSearchClient has no lockstep tags; pin to the exact rev mathlib uses.
update-source-version leanPackages.LeanSearchClient "$lsc_version" \
  --rev="$lsc_rev"

# Packages with leanDeps.
nix-update leanPackages.aesop            --version="$lean4_version"
nix-update leanPackages.importGraph      --version="$lean4_version"

# mathlib (all deps are nix-packaged, no lakeHash needed).
nix-update leanPackages.mathlib          --version="$lean4_version"

# Summary.
changes=()
if [ "$old_lockstep" != "$lean4_version" ]; then
  changes+=("lockstep packages: $old_lockstep -> $lean4_version")
fi
if [ "$old_pw" != "$pw_version" ]; then
  changes+=("proofwidgets: $old_pw -> $pw_version")
fi
if [ "$old_lsc" != "$lsc_version" ]; then
  changes+=("LeanSearchClient: $old_lsc -> $lsc_version")
fi

if [ ${#changes[@]} -eq 0 ]; then
  echo "leanPackages: already up to date at lean4 $lean4_version"
else
  echo "leanPackages: update to lean4 $lean4_version"
  for c in "${changes[@]}"; do
    echo "  - $c"
  done
fi
