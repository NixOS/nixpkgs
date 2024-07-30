#!/usr/bin/env bash

set -o errexit
set -o nounset

if test "$#" != 1; then
  printf >&2 'usage: update-test-samples.bash /path/to/PyAV/source\n'
  exit 2
fi

pyav_source=$1

exec > "$(dirname "$(readlink -f "$0")")/test-samples.toml"

fetch() {
  path=$1
  url=$2
  prefetch_json=$(nix store prefetch-file --json "${url}")
  sri_hash=$(jq -r .hash <<< "${prefetch_json}")
  printf '"%s" = { url = "%s", hash = "%s" }\n' "${path}" "${url}" "${sri_hash}"
}

fetch_all() {
  function=$1
  base_path=$2
  base_url=$3

  samples=$(
    rg \
      --only-matching \
      --no-filename \
      "\\b${function}\\([\"']([^\"']+)[\"']\\)" \
      --replace '$1' \
      "${pyav_source}"
  )
  unique_samples=$(sort -u <<< "${samples}")

  while IFS= read -r sample; do
    fetch "${base_path}/${sample}" "${base_url}/${sample}"
  done <<< "${unique_samples}"
}

fetch_all fate_suite fate-suite "http://fate.ffmpeg.org/fate-suite"
fetch_all curated pyav-curated "https://pyav.org/datasets"
