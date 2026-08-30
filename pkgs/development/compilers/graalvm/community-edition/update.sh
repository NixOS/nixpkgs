#!/usr/bin/env nix-shell
#!nix-shell -p coreutils curl.out nix jq gnused -i bash

# Usage:
# ./update.sh [PRODUCT]
#
# Examples:
#   $ ./update.sh graalvm-ce # will generate ./graalvm-ce/hashes.nix
#   $ ./update.sh # same as above
#   $ ./update.sh graalpy # will generate ./graalpy/hashes.nix
#
# Environment variables:
# FORCE=1        to force the update of a product (e.g.: skip up-to-date checks)
# VERSION=xx.xx  will assume that xx.xx is the new version

set -eou pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"
tmpfile="$(mktemp --suffix=.nix)"
readonly tmpfile

trap 'rm -rf "$tmpfile"' EXIT

info() { echo "[INFO] $*"; }

die() { echo "[ERROR] $*" >&2; exit 1; }

echo_file() { echo "$@" >> "$tmpfile"; }

verlte() {
    [  "$1" = "$(echo -e "$1\n$2" | sort -V | head -n1)" ]
}

readonly product="${1:-graalvm-ce}"
readonly hashes_nix="$product/hashes.nix"
readonly nixpkgs=../../../../..

mkdir -p "$product"

declare -r -A repos=(
  [graalvm-ce]="graalvm/graalvm-ce-builds"
  [graaljs]="oracle/graaljs"
  [graalnodejs]="oracle/graaljs"
  [graalpy]="oracle/graalpython"
  [truffleruby]="truffleruby/truffleruby"
)
readonly repo="${repos[$product]}"

auth_args=()
if [[ -n "${GITHUB_TOKEN:-}" ]]; then
  auth_args+=(-u ":${GITHUB_TOKEN}")
fi

api_url() { echo "https://api.github.com/repos/${repo}/$1"; }

# Unauthenticated requests are capped at 60/hour, so a rate limit is the most
# likely failure here. `-f` discards the response body, so without an explicit
# `die` the script would abort under `set -e` printing nothing at all.
gh_api() {
  curl -fsS "${auth_args[@]}" "$(api_url "$1")" \
    || die "GitHub API request for '${repo}/$1' failed. Set GITHUB_TOKEN if you are being rate limited."
}

gh_status() { curl -sS -o /dev/null -w '%{http_code}' "${auth_args[@]}" "$(api_url "$1")"; }

current_version="$(nix-instantiate "$nixpkgs" --eval --strict -A "graalvmPackages.${product}.version" --json | jq -r)"
readonly current_version

# Releases are tagged `jdk-<version>` up to 25.0.2 and `graal-<version>` from
# the 25.1 innovation stream on, so an explicit VERSION has to try both. Check
# the status code rather than curl's exit status, so that a tag which does not
# exist is not reported the same way as a rate limit.
resolve_tag() {
  local candidate code
  for candidate in "graal-$1" "jdk-$1"; do
    code="$(gh_status "releases/tags/${candidate}")"
    case "$code" in
      200)
        echo "$candidate"
        return 0
        ;;
      404) ;;
      *) die "GitHub API returned HTTP $code for tag '$candidate'. Set GITHUB_TOKEN if you are being rate limited." ;;
    esac
  done
  die "Neither 'graal-$1' nor 'jdk-$1' is a release of '$repo'."
}

# `releases/latest` already carries the asset list, so read the tag out of it
# instead of asking for the same release a second time.
if [[ -z "${VERSION:-}" ]]; then
  release_json="$(gh_api releases/latest)"
  tag="$(jq --raw-output .tag_name <<< "$release_json")"
else
  tag="$(resolve_tag "$VERSION")"
  release_json="$(gh_api "releases/tags/${tag}")"
fi
readonly release_json tag
new_version="${tag//jdk-/}"
new_version="${new_version//graal-/}"
readonly new_version

info "Current version: $current_version"
info "New version: $new_version"
if verlte "$new_version" "$current_version"; then
  if [[ "$new_version" != "$current_version" ]]; then
    # A `jdk-25.0.x` release published after `graal-25.2.4` sorts lower than the
    # packaged version, so it would silently look up-to-date. Say so instead.
    info "WARNING: upstream '$tag' sorts below the packaged $current_version."
    info "WARNING: upstream may have switched release trains. Check manually."
  fi
  info "$product $current_version is up-to-date."
  if [[ -z "${FORCE:-}" ]]; then
    exit 0
  fi
else
  info "$product $current_version is out-of-date. Updating..."
fi

# Make sure to get the `-community` versions! The file names cannot be built
# from the GraalVM version alone, because they embed a component version it
# does not give us: graalvm-community-jdk-25i2-25.0.4, graalnode24,
# graalpy3.12. Match the release's own asset list instead. Anchoring the
# version right after `-community-` also excludes the `-jvm-` variants.
# graalvm-ce cannot be anchored that way, because its file name carries the
# JDK version and not the GraalVM one, so the match below has to be checked
# for ambiguity.
readonly version_re="${new_version//./\\.}"
declare -r -A asset_patterns=(
  [graalvm-ce]="^graalvm-community-jdk-.*_@platform@_bin\\.tar\\.gz$"
  [graaljs]="^graaljs-community-${version_re}-@platform@\\.tar\\.gz$"
  [graalnodejs]="^graalnode(js|[0-9]+)-community-${version_re}-@platform@\\.tar\\.gz$"
  [graalpy]="^graalpy[0-9.]*-community-${version_re}-@platform@\\.tar\\.gz$"
  [truffleruby]="^truffleruby-community-${version_re}-@platform@\\.tar\\.gz$"
)

# Argh, this is really inconsistent...
if [[ "$product" == "graalvm-ce" ]]; then
  declare -r -A platforms=(
    [aarch64-linux]="linux-aarch64"
    [x86_64-linux]="linux-x64"
    [aarch64-darwin]="macos-aarch64"
  )
else
  declare -r -A platforms=(
    [aarch64-linux]="linux-aarch64"
    [x86_64-linux]="linux-amd64"
    [aarch64-darwin]="macos-aarch64"
  )
fi

info "Generating '$hashes_nix' file for '$product' $new_version. This will take a while..."

# Indentation of `echo_file` function is on purpose to make it easier to visualize the output
echo_file "# Generated by $(basename $0) script"
echo_file "{"
echo_file "  \"version\" = \"$new_version\";"
readonly pattern="${asset_patterns[$product]}"
echo_file "  \"hashes\" = {"
for nix_platform in "${!platforms[@]}"; do
  product_platform="${platforms[$nix_platform]}"
  asset_re="${pattern//@platform@/$product_platform}"
  mapfile -t urls < <(jq --raw-output --arg re "$asset_re" \
    '.assets[] | select(.name | test($re)) | .browser_download_url' \
    <<< "$release_json")
  # Never skip a platform, and never guess between candidates. meta.platforms is
  # derived from the attribute names in hashes.nix, so dropping one here silently
  # removes it from the package; and vm-22.3.1 shipped java11, java17 and java19
  # assets side by side, so taking the first match could pin a different JDK per
  # platform.
  if ((${#urls[@]} == 0)); then
    die "No asset matches '$asset_re' in release '$tag'. Upstream naming has probably changed; fix asset_patterns[$product] rather than losing $nix_platform."
  elif ((${#urls[@]} > 1)); then
    die "${#urls[@]} assets match '$asset_re' in release '$tag': ${urls[*]}. Make asset_patterns[$product] more specific."
  fi
  url="${urls[0]}"
  args=("$url")
  # Get current hashes to skip derivations already in /nix/store to reuse cache when the version is the same
  # e.g.: when adding a new product and running this script with FORCE=1
  if [[ "$current_version" == "$new_version" ]] && \
      previous_hash="$(nix-instantiate --eval "$hashes_nix" -A "hashes.$nix_platform.sha256" --json | jq -r)"; then
      args+=("$previous_hash" "--type" "sha256")
  else
      info "Hash in '$product' for '$nix_platform' not found. Re-downloading it..."
  fi
  if ! hash="$(nix-prefetch-url "${args[@]}")"; then
    die "Could not download '$url' for '$nix_platform'."
  fi
echo_file "    \"$nix_platform\" = {"
echo_file "      sha256 = \"$hash\";"
echo_file "      url = \"${url}\";"
echo_file "    };"
done
echo_file "  };"
echo_file "}"

info "Moving the temporary file to '$hashes_nix'"
mv "$tmpfile" "$hashes_nix"

info "Done!"
