{ lib, stdenv, writeScript, coreutils, gnugrep, gnused, common-updater-scripts, nix }:

{ name ? null
, pname ? null
, version ? null
, attrPath ? null
, versionLister
, ignoredVersions ? ""
, rev-prefix ? ""
, odd-unstable ? false
, patchlevel-unstable ? false
# Path to the .nix file to update - this file must contain the version and hash
, file ? null
}:

let
  # where to print git commands and debugging messages
  fileForGitCommands = "update-git-commits.txt";

  scriptVars = lib.toShellVars {
    inherit name pname version file;
    attr_path = attrPath;
    version_lister = versionLister;
    ignored_versions = ignoredVersions;
    rev_prefix = rev-prefix;
    odd_unstable = odd-unstable;
    patchlevel_unstable = patchlevel-unstable;
  };

  # shell script to update package
  updateScript = writeScript "generic-update-script.sh" ''
    #! ${stdenv.shell}
    set -o errexit
    set -x

    ${scriptVars}

    [[ -n "$name" ]] || name="$UPDATE_NIX_NAME"
    [[ -n "$pname" ]] || pname="$UPDATE_NIX_PNAME"
    [[ -n "$version" ]] || version="$UPDATE_NIX_OLD_VERSION"
    [[ -n "$attr_path" ]] || attr_path="$UPDATE_NIX_ATTR_PATH"

    # print header
    echo "# $name" >> ${fileForGitCommands}

    function version_is_ignored() {
      local tag="$1"
      [ -n "$ignored_versions" ] && grep -E "$ignored_versions" <<< "$tag"
    }

    function version_is_unstable() {
      local tag="$1"
      local enforce="$2"
      if [ -n "$odd_unstable" -o -n "$enforce" ]; then
        local minor=$(echo "$tag" | ${gnused}/bin/sed -rne 's,^[0-9]+\.([0-9]+).*,\1,p')
        if [ $((minor % 2)) -eq 1 ]; then
          return 0
        fi
      fi
      if [ -n "$patchlevel_unstable" -o -n "$enforce" ]; then
        local patchlevel=$(echo "$tag" | ${gnused}/bin/sed -rne 's,^[0-9]+\.[0-9]+\.([0-9]+).*$,\1,p')
        if ((patchlevel >= 90)); then
          return 0
        fi
      fi
      return 1
    }

    tags=$(sh -c "$version_lister --pname=$pname --attr-path=$attr_path --file=\"${fileForGitCommands}\"") || exit 1

    # print available tags
    for tag in $tags; do
        echo "#	found $pname version: $tag" >> ${fileForGitCommands}
    done

    # cut any revision prefix not used in the NixOS package version
    if [ -n "$rev_prefix" ]; then
      tags=$(echo "$tags" | ${gnugrep}/bin/grep "^$rev_prefix")
      tags=$(echo "$tags" | ${gnused}/bin/sed -e "s,^$rev_prefix,,")
    fi
    tags=$(echo "$tags" | ${gnugrep}/bin/grep "^[0-9]")

    # sort the tags in decreasing order
    tags=$(echo "$tags" | ${coreutils}/bin/sort --reverse --version-sort)

    # find the newest tag
    # do not consider development versions
    for latest_tag in $tags; do
      if version_is_ignored "$latest_tag"; then
        echo "#   skip ignored version: $pname-$latest_tag" >> ${fileForGitCommands}
        latest_tag=
      elif version_is_unstable "$latest_tag"; then
        echo "#   skip development version: $pname-$latest_tag" >> ${fileForGitCommands}
        latest_tag=
      else
        if version_is_unstable "$latest_tag" "enforce"; then
          echo "#   use potential development version: $pname-$latest_tag" >> ${fileForGitCommands}
        fi
        break
      fi
    done

    if [ -n "$latest_tag" ]; then
      # print commands to commit the changes
      if [ "$version" != "$latest_tag" ]; then
        pfile=$(EDITOR=echo ${nix}/bin/nix edit --extra-experimental-features nix-command -f. "$attr_path")
        echo "   git add $pfile " >> ${fileForGitCommands}
        echo "   git commit -m '$attr_path: $version -> $latest_tag'" >> ${fileForGitCommands}
      fi

      # update the nix expression
      update_source_args=("$attr_path" "$latest_tag")
      if [ -n "$file" ]; then
        update_source_args+=("--file=$file")
      fi
      ${common-updater-scripts}/bin/update-source-version "''${update_source_args[@]}"
    fi

    echo "" >> ${fileForGitCommands}
  '';

in {
  name = "generic-update-script";
  command = [ updateScript ];
}
