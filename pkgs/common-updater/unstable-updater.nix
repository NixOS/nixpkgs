{ lib
, writeShellScript
, coreutils
, git
, nix
, common-updater-scripts
}:

# This is an updater for unstable packages that should always use the latest
# commit.
{ url ? null # The git url, if empty it will be set to src.url
, branch ? null
}:

let
  updateScript = writeShellScript "unstable-update-script.sh" ''
    set -ex

    url="$1"

    # By default we set url to src.url
    if [[ -z "$url" ]]; then
        url="$(${nix}/bin/nix-instantiate $systemArg --eval -E \
                   "with import ./. {}; $UPDATE_NIX_ATTR_PATH.src.url" \
            | tr -d '"')"
    fi

    # Get info about HEAD from a shallow git clone
    tmpdir="$(${coreutils}/bin/mktemp -d)"
    ${git}/bin/git clone --bare --depth=1 \
      ${lib.optionalString (branch != null) "--branch ${branch}"} \
      "$url" "$tmpdir"
    pushd "$tmpdir"
    commit_date="$(${git}/bin/git show -s --pretty='format:%cs')"
    commit_sha="$(${git}/bin/git show -s --pretty='format:%H')"
    popd
    ${coreutils}/bin/rm -rf "$tmpdir"

    # update the nix expression
    ${common-updater-scripts}/bin/update-source-version \
        "$UPDATE_NIX_ATTR_PATH" \
        "unstable-$commit_date" \
        --rev="$commit_sha"
  '';

in [ updateScript url ]

