#! /bin/sh

temp_file=$(mktemp)

cp -v "patch-cmake-files.test.input.txt" "$temp_file"

echo "$0: patching $temp_file"

sh patch-cmake-files.sh patch \
  REGEX_FILE=./patch-cmake-files.regex.diff \
  QT_COMPAT_VERSION=6.2.2 \
  QT_MODULE_NAME=QTBASE \
  NIX_OUT_PATH=/nix/store/xxxx-out \
  NIX_DEV_PATH=/nix/store/xxxx-dev \
  NIX_BIN_PATH=/nix/store/xxxx-bin \
  -- \
  "$temp_file"

echo "$0: done patching $temp_file"

expected_file="patch-cmake-files.test.expected.txt"

echo
echo "comparing ..."
echo "a: $expected_file"
echo "b: $temp_file"
if diff -u --color=always "$expected_file" "$temp_file"
then echo ok
else
  echo "mismatch. to update the expected file:"
  echo "cp $temp_file $expected_file"
fi
