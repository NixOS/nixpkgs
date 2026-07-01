#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils gnugrep jq nix nix-update perl
# shellcheck shell=bash

set -euo pipefail

package_attr=vue-language-server
package_nix=pkgs/by-name/vu/vue-language-server/package.nix

die() {
  echo "error: $*" >&2
  exit 1
}

set_pnpm_settings_from_package_manager() {
  local package_manager=$1

  case "$package_manager" in
    pnpm@10.*)
      pnpm_attr=pnpm_10
      pnpm_expr=pnpm_10
      nodejs_slim_input=
      fetcher_version=3
      ;;
    pnpm@11.*)
      pnpm_attr=pnpm_11
      pnpm_expr='pnpm_11.override { nodejs-slim = nodejs-slim_22; }'
      nodejs_slim_input=nodejs-slim_22
      fetcher_version=4
      ;;
    pnpm@*)
      local major=${package_manager#pnpm@}
      major=${major%%.*}
      die "unsupported pnpm major ${major} in packageManager '${package_manager}'"
      ;;
    *)
      die "unsupported packageManager '${package_manager}': expected pnpm@10.x or pnpm@11.x"
      ;;
  esac
}

read_package_manager() {
  local package_json=$1

  [[ -f "$package_json" ]] || die "package.json not found: ${package_json}"

  local package_manager
  package_manager=$(jq --raw-output '.packageManager // empty' "$package_json")
  [[ -n "$package_manager" ]] || die "packageManager missing from ${package_json}"

  printf '%s\n' "$package_manager"
}

print_pnpm_settings() {
  local package_json=$1
  local package_manager

  package_manager=$(read_package_manager "$package_json")
  set_pnpm_settings_from_package_manager "$package_manager"

  printf 'packageManager=%s\n' "$package_manager"
  printf 'pnpmAttr=%s\n' "$pnpm_attr"
  printf 'pnpmExpr=%s\n' "$pnpm_expr"
  printf 'nodejsSlimInput=%s\n' "$nodejs_slim_input"
  printf 'fetcherVersion=%s\n' "$fetcher_version"
}

rewrite_pnpm_settings() {
  local package_nix=$1

  PNPM_ATTR="$pnpm_attr" \
  PNPM_EXPR="$pnpm_expr" \
  NODEJS_SLIM_INPUT="$nodejs_slim_input" \
  FETCHER_VERSION="$fetcher_version" \
  perl -0pi -e '
    my $pnpm_attr = $ENV{"PNPM_ATTR"};
    my $nodejs_slim_input = $ENV{"NODEJS_SLIM_INPUT"};
    my $nodejs_slim_line = $nodejs_slim_input ? "  $nodejs_slim_input,\n" : "";

    s/  pnpm_(?:10|11),\n(?:  nodejs-slim_22,\n)?/  $pnpm_attr,\n$nodejs_slim_line/
      or die "failed to rewrite pnpm input\n";

    s/^  pnpm = .*;$/  pnpm = $ENV{"PNPM_EXPR"};/m
      or die "failed to rewrite pnpm let binding\n";

    s/fetcherVersion = \d+;/fetcherVersion = $ENV{"FETCHER_VERSION"};/
      or die "failed to rewrite fetcherVersion\n";
  ' "$package_nix"
}

rewrite_pnpm_deps_hash() {
  local package_nix=$1
  local hash_expr=$2

  HASH_EXPR="$hash_expr" perl -0pi -e '
    s{(pnpmDeps = fetchPnpmDeps \{.*?hash = )("sha256-[^"]+"|lib\.fakeHash)(;.*?\n  \};)}{$1$ENV{"HASH_EXPR"}$3}s
      or die "failed to rewrite pnpmDeps.hash\n";
  ' "$package_nix"
}

refresh_pnpm_deps_hash() {
  local package_nix=$1

  rewrite_pnpm_deps_hash "$package_nix" 'lib.fakeHash'

  set +e
  local build_output
  build_output=$(nix-build -A "${package_attr}.pnpmDeps" --no-out-link 2>&1)
  local build_status=$?
  set -e

  if [[ "$build_status" -eq 0 ]]; then
    echo ">> ${package_attr}: pnpmDeps hash already valid"
    return
  fi

  local hash
  hash=$(
    grep --only-matching --extended-regexp 'got:[[:space:]]+sha256-[A-Za-z0-9+/=]+' <<<"$build_output" \
      | grep --only-matching --extended-regexp 'sha256-[A-Za-z0-9+/=]+' \
      | tail -n1 \
      || true
  )

  [[ -n "$hash" ]] || {
    echo "$build_output" >&2
    die "could not parse refreshed pnpmDeps hash"
  }

  rewrite_pnpm_deps_hash "$package_nix" "\"${hash}\""
  nix-build -A "${package_attr}.pnpmDeps" --no-out-link >/dev/null
}

main() {
  if [[ "${1:-}" == "--print-pnpm-settings" ]]; then
    [[ "$#" -eq 2 ]] || die "usage: $0 --print-pnpm-settings package.json"
    print_pnpm_settings "$2"
    return
  fi

  local repo_root
  repo_root=$(git rev-parse --show-toplevel)
  cd "$repo_root"

  nix-update --src-only "$package_attr" "$@"

  local src
  src=$(nix-build -A "${package_attr}.src" --no-out-link)

  local package_manager
  package_manager=$(read_package_manager "${src}/package.json")
  set_pnpm_settings_from_package_manager "$package_manager"

  echo ">> ${package_attr}: upstream packageManager=${package_manager}"
  echo ">> ${package_attr}: using ${pnpm_attr}, fetcherVersion=${fetcher_version}"

  rewrite_pnpm_settings "$package_nix"
  refresh_pnpm_deps_hash "$package_nix"
}

main "$@"
