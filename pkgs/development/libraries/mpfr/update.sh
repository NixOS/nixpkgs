#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl pcre common-updater-scripts

set -efuo pipefail

# Expect the text in format of '<title>GNU MPFR version 4.1.1</title>'
new_version="$(curl -s 'https://www.mpfr.org/mpfr-current/' | pcregrep -o1 '<title>GNU MPFR version ([0-9.]+)</title>')"

# Downloads patches into the given directory and returns the number of patches.
download_patches() {
  local out_dir="$1"

  # Keep downloading patches until we get a 404, signifying that we've reached the end.
  local patch_index=0
  local status_code=200
  local patch_file=''
  until [ "$status_code" -ne 200 ]; do
    let patch_index++
    patch_file="$(printf "patch%02d" "$patch_index")"
    status_code=$(curl --write-out %{http_code} --silent --output "$out_dir/$patch_file.patch" "https://www.mpfr.org/mpfr-$new_version/$patch_file")
  done
  rm -f "$out_dir/$patch_file.patch" # the last file is always bad

  if [ "$status_code" -ne 404 ]; then
    >&2 echo "Expected HTTP status code 404 for patch $patch_index, but got $status_code instead"
    return 1
  fi

  echo "$((patch_index-1))"
}

dir='pkgs/development/libraries/mpfr'  # TODO: extract logic from update-source-version to find this path
patch_dir="$dir/patches"

temp_patch_dir=$(mktemp -d)
patch_count=$(download_patches "$temp_patch_dir")
rm -rf "$patch_dir"
mv "$temp_patch_dir" "$patch_dir"
rmdir "$patch_dir" 2>/dev/null || :  # remove patch dir if empty

full_version="$new_version"
if [ "$patch_count" -gt 0 ]; then
  full_version="$new_version-$patch_count"
fi
update-source-version mpfr "$full_version" --ignore-same-hash
