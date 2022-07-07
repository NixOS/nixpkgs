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
, stableVersion ? false # Use version format according to RFC 107 (i.e. LAST_TAG+date=YYYY-MM-DD)
, tagPrefix ? "" # strip this prefix from a tag name when using stable version
}:

let
  updateScript = writeShellScript "unstable-update-script.sh" ''
    set -ex

    url=""
    branch=""
    use_stable_version=""
    tag_prefix=""

    while (( $# > 0 )); do
        flag="$1"
        shift 1
        case "$flag" in
          --url=*)
            url="''${flag#*=}"
            ;;
          --branch=*)
            branch="''${flag#*=}"
            ;;
          --use-stable-version)
            use_stable_version=1
            ;;
          --tag-prefix=*)
            tag_prefix="''${flag#*=}"
            ;;
          *)
            echo "$0: unknown option ‘''${flag}’"
            exit 1
            ;;
        esac
    done

    # By default we set url to src.url
    if [[ -z "$url" ]]; then
        url="$(${nix}/bin/nix-instantiate $systemArg --eval -E \
                   "with import ./. {}; $UPDATE_NIX_ATTR_PATH.src.gitRepoUrl" \
            | tr -d '"')"
    fi

    # Get info about HEAD from a shallow git clone
    tmpdir="$(${coreutils}/bin/mktemp -d)"

    cloneArgs=(
      --bare
      --depth=1
    )

    if [[ -n "$branch" ]]; then
        cloneArgs+=(--branch="$branch")
    fi

    ${git}/bin/git clone "''${cloneArgs[@]}" "$url" "$tmpdir"

    pushd "$tmpdir"
    commit_date="$(${git}/bin/git show -s --pretty='format:%cs')"
    commit_sha="$(${git}/bin/git show -s --pretty='format:%H')"
    if [[ -z "$use_stable_version" ]]; then
        new_version="unstable-$commit_date"
    else
        depth=100
        while (( $depth < 10000 )); do
            last_tag="$(${git}/bin/git describe --tags --abbrev=0 2> /dev/null || true)"
            if [[ -n "$last_tag" ]]; then
                break
            fi
            ${git}/bin/git fetch --depth="$depth" --tags
            depth=$(( $depth * 2 ))
        done
        if [[ -z "$last_tag" ]]; then
            echo "Cound not found a tag within last 10000 commits" > /dev/stderr
            exit 1
        fi
        if [[ -n "$tag_prefix" ]]; then
          last_tag="''${last_tag#$tag_prefix}"
        fi
        new_version="$last_tag+date=$commit_date"
    fi
    popd
    # ${coreutils}/bin/rm -rf "$tmpdir"

    # update the nix expression
    ${common-updater-scripts}/bin/update-source-version \
        "$UPDATE_NIX_ATTR_PATH" \
        "$new_version" \
        --rev="$commit_sha"
  '';

in [
  updateScript
  "--url=${builtins.toString url}"
] ++ lib.optionals (branch != null) [
  "--branch=${branch}"
] ++ lib.optionals stableVersion [
  "--use-stable-version"
  "--tag-prefix=${tagPrefix}"
]
