#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update curl jq gh

# Usage: ./pkgs/development/lean-modules/update.sh [version]

set -euo pipefail

lean4_version="${1:-$(curl -sL https://api.github.com/repos/leanprover/lean4/releases/latest | jq -r '.tag_name' | sed 's/^v//')}"

dir=$(dirname "$0")
FAKE="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="

old_lean4=$(nix eval --raw .#leanPackages.lean4.version 2>/dev/null || echo "")

nix-update leanPackages.lean4 --version="$lean4_version"

manifest=$(curl -sL "https://raw.githubusercontent.com/leanprover-community/mathlib4/v${lean4_version}/lake-manifest.json")

known_deps="Cli LeanSearchClient Qq aesop batteries importGraph plausible proofwidgets"
manifest_deps=$(echo "$manifest" | jq -r '[.packages[].name] | sort | join(" ")')
if [ "$manifest_deps" != "$known_deps" ]; then
  echo "ERROR: mathlib dependency set has changed" >&2
  echo "  expected: $known_deps" >&2
  echo "  got:      $manifest_deps" >&2
  exit 1
fi

patch_pkg() {
  local pkgname="$1" repo="$2"
  local file="$dir/$pkgname/default.nix"
  local inputRev rev version
  inputRev=$(echo "$manifest" | jq -r ".packages[] | select(.name == \"$pkgname\") | .inputRev")
  rev=$(echo "$manifest" | jq -r ".packages[] | select(.name == \"$pkgname\") | .rev")

  if [[ "$inputRev" =~ ^v[0-9] ]]; then
    version="${inputRev#v}"
    # tag = "v${...version}" auto-follows; convert rev → tag if needed.
    if grep -q 'rev = "' "$file"; then
      sed -i -E "s|rev = \"[^\"]*\";|tag = \"${inputRev}\";|" "$file"
    fi
  else
    local tmp=$(mktemp -d)
    git clone --bare --filter=tree:0 --depth=100 --single-branch "https://github.com/$repo" "$tmp" 2>/dev/null
    local latest_tag=$(git -C "$tmp" describe --tags --abbrev=0 --match 'v[0-9]*' "$rev" 2>/dev/null | sed 's/^v//')
    rm -rf "$tmp"
    local date=$(gh api "repos/$repo/commits/$rev" --jq '.commit.committer.date[:10]')
    version="${latest_tag:-0}-unstable-$date"
    if grep -q 'rev = "' "$file"; then
      sed -i -E "s|rev = \"[^\"]*\";|rev = \"${rev}\";|" "$file"
    else
      sed -i -E "s|tag = \"[^\"]*\";|rev = \"${rev}\";|" "$file"
    fi
  fi

  sed -i -E "s|version = \"[^\"]*\";|version = \"${version}\";|" "$file"
  sed -i "0,/hash = \"sha256-[^\"]*\"/{s||hash = \"$FAKE\"|}" "$file"
}

echo "--- mathlib tree ---"

patch_pkg batteries        leanprover-community/batteries
patch_pkg Qq               leanprover-community/quote4
patch_pkg aesop            leanprover-community/aesop
patch_pkg Cli              leanprover/lean4-cli
patch_pkg plausible        leanprover-community/plausible
patch_pkg importGraph      leanprover-community/import-graph
patch_pkg proofwidgets     leanprover-community/ProofWidgets4
patch_pkg LeanSearchClient leanprover-community/LeanSearchClient

sed -i -E "/lean4-mathlib/,/version/s|version = \"[^\"]*\";|version = \"${lean4_version}\";|" "$dir/mathlib/default.nix"
if ! grep -q 'tag = "v\${finalAttrs.version}"' "$dir/mathlib/default.nix"; then
  sed -i -E 's|tag = "v[^"]*";|tag = "v${finalAttrs.version}";|' "$dir/mathlib/default.nix"
fi
sed -i "0,/hash = \"sha256-[^\"]*\"/{s||hash = \"$FAKE\"|}" "$dir/mathlib/default.nix"

prefetch() {
  local out newhash
  out=$(nix build ".#leanPackages.${1}.${2:-src}" 2>&1 || true)
  newhash=$(echo "$out" | awk '/got:/ {print $2}' | head -1)
  if [ -z "$newhash" ]; then
    echo "ERROR: failed to prefetch $1.${2:-src}" >&2
    echo "$out" >&2
    return 1
  fi
  echo "$newhash"
}

for pkg in batteries Qq aesop Cli plausible importGraph proofwidgets LeanSearchClient mathlib; do
  echo "  prefetching $pkg"
  newhash=$(prefetch "$pkg")
  sed -i "s|$FAKE|$newhash|" "$dir/$pkg/default.nix"
done

echo "  prefetching proofwidgets npmDeps"
# Replace the second hash (the one inside fetchNpmDeps) with fake.
sed -i "0,/hash = \"sha256-[^\"]*\"/!{s|hash = \"sha256-[^\"]*\"|hash = \"$FAKE\"|}" "$dir/proofwidgets/default.nix"
newhash=$(prefetch proofwidgets npmDeps)
sed -i "s|$FAKE|$newhash|" "$dir/proofwidgets/default.nix"

echo "leanPackages.lean4: $old_lean4 -> $lean4_version"
echo "https://github.com/leanprover-community/mathlib4/blob/v${lean4_version}/lake-manifest.json"
echo "https://github.com/leanprover/lean4/releases/tag/v${lean4_version}"
