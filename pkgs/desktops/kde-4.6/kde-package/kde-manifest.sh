#!/bin/sh

# Usage: download kde release to $dir, then run
# $0 $dir

dir=$1

if [[ ! -d "${dir}" ]]; then
  echo "${dir} is not a directory (or doesn't exist)!" >&2
  exit 1
fi

release=$(ls "${dir}"/kdelibs-*.tar.bz2 | \
	sed -e 's/.*kdelibs-//' -e 's/\.tar\.bz2//')

echo "Detected release ${release}" >&2

exec > "manifest-${release}.nix"
echo "["
for i in `cd "${dir}"; ls *-${release}.tar.bz2`; do
  module=${i%-${release}.tar.bz2}
  echo -n "${module}.. " >&2
  hash=$(nix-hash --type sha256 --flat --base32 "${dir}/${i}")
  echo "{"
  echo "  module = \"${module}\";"
  echo "  sha256 = \"${hash}\";"
  echo "}"
  echo $hash >&2
done
echo "]"
