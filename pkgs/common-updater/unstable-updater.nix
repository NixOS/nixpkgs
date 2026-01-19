{
  lib,
  writeShellApplication,
  coreutils,
  git,
  nix,
  common-updater-scripts,
}:

# This is an updater for unstable packages that should always use the latest
# commit.
# To use this updater, add the following to your package set:
# passthru.updateScript = unstableGitUpdater { };
# relevant attributes can be passed as below:

{
  url ? null, # The git url, if empty it will be set to src.gitRepoUrl
  branch ? null,
  hardcodeZeroVersion ? false, # Use a made-up version "0" instead of latest tag. Use when the project's tagging system is incompatible with what we expect from versions
  tagFormat ? "*", # A `git describe --tags --match '<format>'` pattern that tags must match to be considered
  tagPrefix ? null, # strip this prefix from a tag name
  tagConverter ? null, # A command to convert more complex tag formats. It receives the git tag via stdin and should convert it into x.y.z format to stdout
  shallowClone ? true,
}:

assert lib.asserts.assertMsg (
  tagPrefix == null || tagConverter == null
) "Can only use either tagPrefix or tagConverter!";

let
  updateScript = writeShellApplication {
    name = "unstable-update-script";
    runtimeInputs = [
      common-updater-scripts
      coreutils
      git
      nix
    ];
    text = ''
      set -ex

      url=""
      branch=""
      hardcode_zero_version=""
      tag_format=""
      tag_prefix=""
      tag_converter=""
      shallow_clone=""
      : "''${systemArg:=}"

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
          # system argument cannot be passed as 1 argument
          # shellcheck disable=SC2086
          url="$(nix-instantiate $systemArg --eval -E \
                     "with import ./. {}; $UPDATE_NIX_ATTR_PATH.src.gitRepoUrl" \
              | tr -d '"')"
      fi

      # Get info about HEAD from a shallow git clone
      tmpdir="$(mktemp -d)"

      cloneArgs=()

      if [[ "$shallow_clone" == "1" ]]; then
          cloneArgs+=(--depth=1)
      fi

      if [[ -n "$branch" ]]; then
          cloneArgs+=(--branch="$branch")
      fi

      git clone "''${cloneArgs[@]}" "$url" "$tmpdir"
      getLatestVersion() {
          git describe --tags --abbrev=0 --match "''${tag_format}" 2> /dev/null || true
      }

      pushd "$tmpdir"
      commit_date="$(git show -s --pretty='format:%cs')"
      commit_sha="$(git show -s --pretty='format:%H')"
      last_tag=""
      if [[ -z "$hardcode_zero_version" ]]; then
          if [[ "$shallow_clone" == "1" ]]; then
              depth=100
              while (( depth < 10000 )); do
                  last_tag="$(getLatestVersion)"
                  if [[ -n "$last_tag" ]]; then
                      break
                  fi
                  git fetch --depth="$depth" --tags
                  depth=$(( depth * 2 ))
              done

              if [[ -z "$last_tag" ]]; then
                  # To be extra sure, check if full history helps with finding a tag
                  git fetch --tags
                  last_tag="$(getLatestVersion)"
              fi
          else
              last_tag="$(getLatestVersion)"
          fi
          if [[ -z "$last_tag" ]]; then
              last_tag="0"
          fi
          if [[ -n "$tag_prefix" ]]; then
              echo "Stripping prefix '$tag_prefix' from tag '$last_tag'"
              last_tag="''${last_tag#"''${tag_prefix}"}"
          fi
          if [[ -n "$tag_converter" ]]; then
              echo "Running '$last_tag' through: $tag_converter"
              last_tag="$(echo "''${last_tag}" | ''${tag_converter})"
          fi
      else
          last_tag="0"
      fi
      if [[ ! "$last_tag" =~ ^[[:digit:]] ]]; then
          echo "Last tag '$last_tag' does not start with a digit" > /dev/stderr
          exit 1
      fi
      new_version="$last_tag-unstable-$commit_date"
      popd
      # rm -rf "$tmpdir"

      # update the nix expression
      update-source-version \
          "$UPDATE_NIX_ATTR_PATH" \
          "$new_version" \
          --rev="$commit_sha"
    '';
  };

in
[
  (lib.getExe updateScript)
  "--url=${toString url}"
  "--tag-format=${tagFormat}"
]
++ lib.optionals (branch != null) [
  "--branch=${branch}"
]
++ lib.optionals (tagPrefix != null) [
  "--tag-prefix=${tagPrefix}"
]
++ lib.optionals (tagConverter != null) [
  "--tag-converter=${tagConverter}"
]
++ lib.optionals hardcodeZeroVersion [
  "--hardcode-zero-version"
]
++ lib.optionals shallowClone [
  "--shallow-clone"
]
