#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl jq nix
# shellcheck shell=bash

set -o errexit -o nounset -o pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../../.."

curl_args=(--fail --location --silent --show-error)
if [[ -n "${GITHUB_TOKEN:-}" ]]; then
  curl_args+=(--user ":${GITHUB_TOKEN}")
fi

# The repository also publishes support packages under tags such as
# wizql-support-0.0.1, so pick the highest numeric tag.  Many releases share
# the same created_at date, so compare versions instead of trusting the order
# of the API response.
release="$(
  curl "${curl_args[@]}" \
    https://api.github.com/repos/razein97/Wizql-Issue-Tracker/releases?per_page=100 |
    jq --exit-status '
      map(select(.draft == false and .prerelease == false and (.tag_name | test("^[0-9]+(\\.[0-9]+)*$"))))
      | max_by(.tag_name | split(".") | map(tonumber))'
)"
version="$(jq --exit-status --raw-output .tag_name <<<"${release}")"
old_version="$(nix-instantiate --eval --raw --attr wizql.version)"

if [[ "${version}" == "${old_version}" ]]; then
  echo "wizql is already at ${version}"
  exit 0
fi

# Collect every hash before editing package.nix, so that a release with a
# missing asset leaves the file untouched.
platforms="$(nix-instantiate --eval --json --strict --attr wizql.meta.platforms)"
declare -A hashes=()
for system in $(jq --raw-output '.[]' <<<"${platforms}"); do
  old_url="$(nix-instantiate --eval --raw --system "${system}" --attr wizql.src.url)"
  name="${old_url##*/}"
  name="${name//"${old_version}"/"${version}"}"
  digest="$(
    jq --exit-status --raw-output --arg name "${name}" \
      '.assets[] | select(.name == $name) | .digest | select(startswith("sha256:"))' \
      <<<"${release}"
  )"
  hashes["${system}"]="$(nix-hash --type sha256 --to-sri "${digest#sha256:}")"
done

for system in "${!hashes[@]}"; do
  update-source-version wizql "${version}" "${hashes[${system}]}" \
    --system="${system}" --ignore-same-version --ignore-same-hash
done
