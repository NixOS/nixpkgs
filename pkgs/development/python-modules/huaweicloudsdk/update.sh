#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nixfmt-tree nix-update xmlstarlet

set -eu -o pipefail

nix-update python3Packages.huaweicloudsdkcore --commit --build

source_file=pkgs/development/python-modules/huaweicloudsdk/default.nix

repo=huaweicloud-sdk-python-v3
owner=huaweicloud

version=$(curl -s https://pypi.org/pypi/huaweicloudsdkcore/json | jq -r '.info.version')
old_version=$(awk -F'"' '/version = / { print $2; exit }' "$source_file")

echo "Updating ${repo} from ${old_version} to ${version}"

if [ "$version" = "$old_version" ]; then
  echo "${source_file} already at ${version}; nothing to do"
  exit 0
fi

archive_url="https://github.com/${owner}/${repo}/archive/refs/tags/v${version}.tar.gz"
prefetched_hash=$(nix-prefetch-url --type sha256 "$archive_url")
sri_hash="$(nix --extra-experimental-features nix-command hash to-sri --type sha256 "$prefetched_hash")"

tmp_dir=$(mktemp -d)
cleanup() {
  rm -rf "$tmp_dir"
}
trap cleanup EXIT

archive_tar="$tmp_dir/repo.tar.gz"
curl -L --fail --silent --show-error "$archive_url" -o "$archive_tar"
tar -xzf "$archive_tar" -C "$tmp_dir"
repo_root="$tmp_dir/${repo}-${version}"

if [ ! -d "$repo_root" ]; then
  echo "Unable to find extracted repository root: $repo_root" >&2
  exit 1
fi

mapfile -t services < <(
  find "$repo_root" -maxdepth 1 -mindepth 1 -type d -name 'huaweicloud-sdk-*' \
    -printf '%f\n' \
  | sed 's/^huaweicloud-sdk-//' \
  | sort \
  | grep -vE '^(all|codecheck|core)$'
)

if [ "${#services[@]}" -eq 0 ]; then
  echo "No service directories found in ${repo_root}" >&2
  exit 1
fi

entries_file="$tmp_dir/entries.nix"
for service in "${services[@]}"; do
  printf '  huaweicloudsdk%s = buildHuaweiCloudSdkPackage "%s";\n' "$service" "$service" >> "$entries_file"
done

awk -v version="$version" -v hash="$sri_hash" -v entries_file="$entries_file" '
  BEGIN {
    while ((getline line < entries_file) > 0) {
      entries = entries line "\n"
    }
    close(entries_file)
    in_attrset = 0
    replaced_attrset = 0
  }

  {
    if ($0 ~ /^[[:space:]]*version = /) {
      print "      version = \"" version "\";"
      next
    }
    if ($0 ~ /^[[:space:]]*hash = /) {
      print "        hash = \"" hash "\";"
      next
    }

    if (!replaced_attrset && $0 ~ /^in$/) {
      print
      in_attrset = 1
      next
    }

    if (in_attrset && $0 ~ /^\{$/) {
      print
      printf "%s", entries
      next
    }

    if (in_attrset && $0 ~ /^\}$/) {
      print
      in_attrset = 0
      replaced_attrset = 1
      next
    }

    if (in_attrset) {
      next
    }

    print
  }
' "$source_file" > "$tmp_dir/default.nix"

cp "$tmp_dir/default.nix" "$source_file"

treefmt "$source_file"

git commit "$source_file" -m "python3Packages.huaweicloudsdk: ${old_version} -> ${version}"
