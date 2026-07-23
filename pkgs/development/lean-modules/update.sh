#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update common-updater-scripts curl jq

# Update the leanPackages set.
#
# Usage:
#   ./pkgs/development/lean-modules/update.sh [version]

set -euo pipefail

lean4_version="${1:-$(curl -sL https://api.github.com/repos/leanprover/lean4/releases/latest | jq -r '.tag_name' | sed 's/^v//')}"

# Snapshot before any updates.
old_lockstep=$(nix eval --raw .#leanPackages.mathlib.version 2>/dev/null || echo "")
old_pw=$(nix eval --raw .#leanPackages.proofwidgets.version 2>/dev/null || echo "")
old_lsc=$(nix eval --raw .#leanPackages.LeanSearchClient.version 2>/dev/null || echo "")

run() { echo "  $*"; "$@"; }

# --- lean4 toolchain ---

run nix-update leanPackages.lean4 --version="$lean4_version"

# --- mathlib dependency tree ---
# Versions are derived from mathlib's lake-manifest.json at the
# matching lean4 tag. Most packages release in lockstep with lean4;
# ProofWidgets and LeanSearchClient have their own versioning.

manifest=$(curl -sL "https://raw.githubusercontent.com/leanprover-community/mathlib4/v${lean4_version}/lake-manifest.json")

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

echo "--- mathlib tree ---"

# Lockstep version synchronization.
dir=pkgs/development/lean-modules
for pkg in batteries aesop Qq plausible Cli importGraph mathlib; do
  sed -i "s|tag = \"v${old_lockstep}\"|tag = \"v${lean4_version}\"|" "$dir/$pkg/default.nix"
done

run nix-update leanPackages.batteries    --version="$lean4_version"
run nix-update leanPackages.Qq           --version="$lean4_version"
run nix-update leanPackages.plausible    --version="$lean4_version"
run nix-update leanPackages.Cli          --version="$lean4_version"
run nix-update leanPackages.proofwidgets --version="$pw_version"
run update-source-version leanPackages.LeanSearchClient "$lsc_version" --rev="$lsc_rev"
run nix-update leanPackages.aesop        --version="$lean4_version"
run nix-update leanPackages.importGraph  --version="$lean4_version"
run nix-update leanPackages.mathlib      --version="$lean4_version"

# --- summary ---

changes=()
[ "$old_lockstep" != "$lean4_version" ] && changes+=("mathlib tree: $old_lockstep -> $lean4_version")
[ "$old_pw" != "$pw_version" ] && changes+=("proofwidgets: $old_pw -> $pw_version")
[ "$old_lsc" != "$lsc_version" ] && changes+=("LeanSearchClient: $old_lsc -> $lsc_version")

if [ ${#changes[@]} -eq 0 ]; then
  echo "status: up-to-date"
  exit 0
fi

echo "commit-title: leanPackages: lean4 $old_lockstep -> $lean4_version"
echo "---"
for c in "${changes[@]}"; do
  echo "  - $c"
done
echo "---"
echo "manifest-source: https://github.com/leanprover-community/mathlib4/blob/v${lean4_version}/lake-manifest.json"
echo "lean4-release: https://github.com/leanprover/lean4/releases/tag/v${lean4_version}"
