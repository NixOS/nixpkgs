#! /bin/sh

# patch files

# first argument is "patch"
# first group of arguments are key=val pairs
# group delimiter: --
# second group of arguments are files to patch

# perl must be in $PATH

set -eu

log() {
  echo "$0: $*" >&2
}

if [ $# = 0 ] || [ "$1" != patch ]; then
  log "fatal error: first argument must be 'patch'"
  log "hint: this script should not be in buildInputs"
  exit 1
fi
shift

log "arguments: $*" # debug

for arg in "$@"
do
  case "$arg" in
    *=*) log "eval $arg"; eval "$arg"; shift;;
    --) shift; break;;
    *) log "fatal error: bad argument '$arg'. expected key=val or --"; exit 1;;
  esac
done

if [ $# = 0 ]; then
  log "no files to patch -> ignore"
  exit 0
fi

log "patching $# files"

cat <<EOF
$0: debug:
  REGEX_FILE = $REGEX_FILE
  QT_COMPAT_VERSION = $QT_COMPAT_VERSION
  QT_MODULE_NAME = $QT_MODULE_NAME
  NIX_OUT_PATH = $NIX_OUT_PATH
  NIX_DEV_PATH = $NIX_DEV_PATH
  NIX_BIN_PATH = $NIX_BIN_PATH
EOF

if ! [ -e "$REGEX_FILE" ]; then
  log "fatal error: missing REGEX_FILE: $REGEX_FILE"
  exit 1
fi

log "build regex"

escape_b() {
  echo "$1" | sed 's,/,\\/,g'
}

regex="$( ( echo; cat "$REGEX_FILE"; echo ) | perl -p -0 -e '
  s/\n#[^\n]*/\n/g;
  s/\(\(QT_COMPAT_VERSION\)\)/'"$QT_COMPAT_VERSION"'/g;
  s/\(\(QT_MODULE_NAME\)\)/'"$QT_MODULE_NAME"'/g;
  s/\(\(NIX_OUT_PATH\)\)/'"$(escape_b "$NIX_OUT_PATH")"'/g;
  s/\(\(NIX_DEV_PATH\)\)/'"$(escape_b "$NIX_DEV_PATH")"'/g;
  s/\(\(NIX_BIN_PATH\)\)/'"$(escape_b "$NIX_BIN_PATH")"'/g;
  s/([^\n])\//\1\\\//g;
  s/\n-([^\n]+)\n\+([^\n]*)(?:\n\/([^\n]+))?\n/s\/\1\/\2\/\3;\n/g
')"

log "regex:"; echo "$regex" # debug

#log "$# input files:"; for f in "$@"; do echo "  $f"; done # debug

exec perl -00 -p -i -e "$regex" "$@"
