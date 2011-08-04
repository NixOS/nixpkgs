#!/bin/sh

# Usage: download kde-l10n to $dir, then run
# $0 $dir

dir=$1

if [[ ! -d "${dir}" ]]; then
  echo "${dir} is not a directory (or doesn't exist)!" >&2
  exit 1
fi

release=$(ls "${dir}"/kde-l10n-en_GB-*.tar.bz2 | \
	sed -e 's/.*en_GB-//' -e 's/\.tar\.bz2//')

echo "Detected release ${release}" >&2

exec > "manifest-${release}.nix"
echo "["
for i in `cd "${dir}"; ls kde-l10n-*-${release}.tar.bz2`; do
  lang=${i%-${release}.tar.bz2}
  lang=${lang#kde-l10n-}
  echo -n "${lang}.. " >&2
  hash=$(nix-hash --type sha256 --flat --base32 "${dir}/${i}")
  echo "{"
  echo "  lang = \"${lang}\";"
  echo "  saneName = \"$(echo $lang | sed s^@^_^g)\";"
  echo "  sha256 = \"${hash}\";"
  echo "}"
  echo $hash >&2
done
echo "]"
