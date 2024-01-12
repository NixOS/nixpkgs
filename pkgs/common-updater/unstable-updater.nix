{ lib
, writeShellScript
, coreutils
, git
, nix
, common-updater-scripts
}:

# This is an updater for unstable packages that should always use the latest
# commit.
{ url ? null # The git url, if empty it will be set to src.gitRepoUrl
, branch ? null
, hardcodeZeroVersion ? false # Use a made-up version "0" instead of latest tag. Use when there is no previous release, or the project's tagging system is incompatible with what we expect from versions
, tagPrefix ? "" # strip this prefix from a tag name
, shallowClone ? true
}:

let
  updateScript = writeShellScript "unstable-update-script.sh" ''
    set -ex

    url=""
    branch=""
    hardcode_zero_version=""
    tag_prefix=""
    shallow_clone=""

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
          --hardcode-zero-version)
            hardcode_zero_version=1
            ;;
          --tag-prefix=*)
            tag_prefix="''${flag#*=}"
            ;;
          --shallow-clone)
            shallow_clone=1
            ;;
          *)
            echo "$0: unknown option ‘''${flag}’"
            exit 1
            ;;
        esac
    done

    # By default we set url to src.gitRepoUrl
    if [[ -z "$url" ]]; then
        url="$(${nix}/bin/nix-instantiate $systemArg --eval -E \
                   "with import ./. {}; $UPDATE_NIX_ATTR_PATH.src.gitRepoUrl" \
            | tr -d '"')"
    fi

    # Get info about HEAD from a shallow git clone
    tmpdir="$(${coreutils}/bin/mktemp -d)"

    cloneArgs=(
      --bare
    )

    if [[ "$shallow_clone" == "1" ]]; then
        cloneArgs+=(--depth=1)
    fi

    if [[ -n "$branch" ]]; then
        cloneArgs+=(--branch="$branch")
    fi

    ${git}/bin/git clone "''${cloneArgs[@]}" "$url" "$tmpdir"

    pushd "$tmpdir"
    commit_date="$(${git}/bin/git show -s --pretty='format:%cs')"
    commit_sha="$(${git}/bin/git show -s --pretty='format:%H')"
    last_tag=""
    if [[ -z "$hardcode_zero_version" ]]; then
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
            echo "Cound not find a tag within last 10000 commits" > /dev/stderr
            exit 1
        fi
        if [[ -n "$tag_prefix" ]]; then
          last_tag="''${last_tag#$tag_prefix}"
        fi
        if [[ ! "$last_tag" =~ ^[[:digit:]] ]]; then
            echo "Last tag '$last_tag' (after removing prefix '$tag_prefix') does not start with a digit" > /dev/stderr
            exit 1
        fi
    else
        last_tag="0"
    fi
    new_version="$last_tag-unstable-$commit_date"
    popd
    # ${coreutils}/bin/rm -rf "$tmpdir"

    # update the nix expression
    ${common-updater-scripts}/bin/update-source-version \
        "$UPDATE_NIX_ATTR_PATH" \
        "$new_version" \
        --rev="$commit_sha"
  '';

in
[
  updateScript
  "--url=${builtins.toString url}"
  "--tag-prefix=${tagPrefix}"
] ++ lib.optionals (branch != null) [
  "--branch=${branch}"
] ++ lib.optionals hardcodeZeroVersion [
  "--hardcode-zero-version"
] ++ lib.optionals shallowClone [
  "--shallow-clone"
]
