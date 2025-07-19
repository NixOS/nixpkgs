#!/usr/bin/env nix-shell
#!nix-shell -i bash -p subversion common-updater-scripts

attr=the-dark-mod
svnUrl=https://svn.thedarkmod.com/publicsvn/darkmod_src/tags

versions=$(svn list $svnUrl | rg "^\d+.\d+/\$" | tr -d '/')
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; $attr.version" | tr -d '"')

echo "Current TDM version: $currentVersion"
for version in $versions; do
  [ "$version" = "$(printf '%s\n%s' "$version" "$currentVersion" | sort -V | head -n1)" ] && continue

  echo "New version found: $version";
  rev=$(svn info $svnUrl/$version --show-item last-changed-revision)

  echo "Updating engine";
  update-source-version "$attr-unwrapped" "$version" --rev="$rev"

  echo "Updating assets";
  oldAssetsHash=$(nix-instantiate --eval --strict -A "the-dark-mod-assets.drvAttrs.outputHash" | tr -d '"')
  nix-build --no-out-link -A "the-dark-mod-assets" 2>&1 | tee assets.log
  newAssetsHash=$(grep -P --only-matching  "got: +.+[:-]\K.+" assets.log)

  sed -i.cmp 's,$oldAssetsHash,$newAssetsHash,' pkgs/by-name/th/the-dark-mod-assets/package.nix

  echo "Update complete!";

  exit 0
done

echo "Already at latest version"

