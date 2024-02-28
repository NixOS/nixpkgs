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
, tagFormat ? ".*" # A grep -Eo pattern that tags must match to be considered valid
, tagPrefix ? "" # strip this prefix from a tag name
, tagConverter ? null # A command to convert more complex tag formats. It receives the git tag via stdin and should convert it into x.y.z format to stdout
, shallowClone ? true
}:

let
  updateScript = writeShellScript "unstable-update-script.sh" ''
    set -ex

    url=""
    branch=""
    hardcode_zero_version=""
    tag_format=""
    tag_prefix=""
    tag_converter=""
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
          --tag-format=*)
            tag_format="''${flag#*=}"
            ;;
          --tag-prefix=*)
            tag_prefix="''${flag#*=}"
            ;;
          --tag-converter=*)
            tag_converter="''${flag#*=}"
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
        if [[ "$shallow_clone" == "1" ]]; then
            depth=100
            while (( $depth < 10000 )); do
                last_tag="$(${git}/bin/git describe --tags --abbrev=0 2> /dev/null || true)"
                if [[ -n "$last_tag" ]]; then
                    tag_matched="$(echo ''${last_tag} | grep -Eo ''${tag_format} || true)"
                    if [[ -z "$tag_matched" ]]; then
                        ${lib.getExe git} tag -d ''${last_tag}
                        continue
                    fi
                    break
                fi
                ${git}/bin/git fetch --depth="$depth" --tags
                depth=$(( $depth * 2 ))
            done

            if [[ -z "$last_tag" ]]; then
                # To be extra sure, check if full history helps with finding a tag
                git fetch --tags
                last_tag="$(${git}/bin/git describe --tags --abbrev=0 2> /dev/null || true)"
            fi
        else
            last_tag="$(${git}/bin/git describe --tags --abbrev=0 2> /dev/null || true)"
        fi
        if [[ -z "$last_tag" ]]; then
            last_tag="0"
        fi
        if [[ -n "$tag_prefix" ]]; then
            echo "Stripping prefix '$tag_prefix' from tag '$last_tag'"
            last_tag="''${last_tag#$tag_prefix}"
        fi
        if [[ -n "$tag_converter" ]]; then
            echo "Running '$last_tag' through: $tag_converter"
            last_tag="$(echo ''${last_tag#$tag_prefix} | ''${tag_converter})"
        fi
        if [[ ! "$last_tag" =~ ^[[:digit:]] ]]; then
            echo "Last tag '$last_tag' does not start with a digit" > /dev/stderr
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
  "--tag-format=${tagFormat}"
  "--tag-prefix=${tagPrefix}"
] ++ lib.optionals (branch != null) [
  "--branch=${branch}"
] ++ lib.optionals (tagConverter != null) [
  "--tag-converter=${tagConverter}"
] ++ lib.optionals hardcodeZeroVersion [
  "--hardcode-zero-version"
] ++ lib.optionals shallowClone [
  "--shallow-clone"
]
