#! /bin/sh

# patch files

# first group of parameters are key=val pairs
# group delimiter: --
# second group of parameters are files to patch

# perl must be in $PATH

set -eu

for arg in "$@"
do
  [ "$arg" = "--" ] && { shift; break; }
  echo "$0 eval $arg"
  eval "$arg"
  shift
done

if [ $# = 0 ]; then
    echo "$0: no files in argv -> ignore"
    exit 0
fi

echo "$0: patching $# files"

cat <<EOF
$0: debug:
  REGEX_FILE = $REGEX_FILE
  qtCompatVersion = $qtCompatVersion
  QT_MODULE_NAME = $QT_MODULE_NAME
  NIX_OUT_PATH = $NIX_OUT_PATH
  NIX_DEV_PATH = $NIX_DEV_PATH
  NIX_BIN_PATH = $NIX_BIN_PATH
EOF

echo "$0: build regex"

escape_b() {
  echo "$1" | sed 's,/,\\/,g'
}

regex="$( ( echo; cat $REGEX_FILE; echo ) | perl -p -0 -e '
  s/\n#[^\n]*/\n/g;
  s/\(\(qtCompatVersion\)\)/'"$qtCompatVersion"'/g;
  s/\(\(QT_MODULE_NAME\)\)/'"$QT_MODULE_NAME"'/g;
  s/\(\(NIX_OUT_PATH\)\)/'"$(escape_b "$NIX_OUT_PATH")"'/g;
  s/\(\(NIX_DEV_PATH\)\)/'"$(escape_b "$NIX_DEV_PATH")"'/g;
  s/\(\(NIX_BIN_PATH\)\)/'"$(escape_b "$NIX_BIN_PATH")"'/g;
  s/([^\n])\//\1\\\//g;
  s/\n-([^\n]+)\n\+([^\n]*)(?:\n\/([^\n]+))?\n/s\/\1\/\2\/\3;\n/g
')"

echo "$0: regex:"; echo "$regex" # debug

#echo "$0: $# input files:"; for f in "$@"; do echo "  $f"; done # debug

exec perl -00 -p -i -e "$regex" "$@"
