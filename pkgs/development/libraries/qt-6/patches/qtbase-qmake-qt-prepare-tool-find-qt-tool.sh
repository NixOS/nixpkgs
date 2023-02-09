# find absolute path of a qt tool

# this script is called from qtbase-dev/mkspecs/features/qt_functions.prf

# resolution order:
# 1. try $QMAKE_<TOOL_NAME> - example: tool_name=lrelease -> $QMAKE_LRELEASE
# 2. search in $instloc passed by qt_functions.prf
# 3. search in all prefixes in $QMAKEPATH
# 4. search in $PATH

# limitations:
# tool_name and instloc_dir must be a basename, cannot be a path.

if [ $# == 0 ] || (( $# > 2 )) || [ -z "$1" ]; then
    echo 'usage: find-qt-tool.sh tool_name [instloc]' >&2
    exit 1
fi

# example: lrelease
tool_name="$1"

# absolute path to bin/ or libexec/.
# can also be just bin or libexec, or empty.
instloc="${2:-bin}"

if (( "${NIX_DEBUG:-0}" >= 1 )); then
  log() {
    echo "find-qt-tool.sh $tool_name: $*" >&2
  }
else
  log() { :; }
fi

# test: tool was not found
#log "not found"; exit

# example: some-tool.pl -> QMAKE_SOME_TOOL_PL
tool_cmd_env=QMAKE_$(echo "$tool_name" | tr '[:lower:][:punct:]' '[:upper:]_')
tool_cmd="${!tool_cmd_env}"
if [ -n "$tool_cmd" ]; then
  log "using env $tool_cmd_env: $tool_cmd"
  echo "$tool_cmd"
  exit
fi

instloc_prefix=${instloc%/*} # usually ${qtbase.dev}
instloc_dir=${instloc##*/} # bin or libexec

if [ "${instloc_prefix:0:1}" != '/' ]; then
    log "ignoring non-absolute instloc_prefix: $instloc_prefix"
    instloc_prefix=
fi

if [ -z "$instloc_dir" ]; then
    log 'instloc_dir is empty, using instloc_dir=bin'
    instloc_dir=bin
fi

tool_relpath="$instloc_dir/$tool_name"
while read -d: prefix; do
  if ! [ -e "$prefix" ]; then continue; fi
  tool_cmd="$prefix/$tool_relpath"
  if ! [ -e "$tool_cmd" ]; then
    #log "missing in QMAKEPATH: tool_cmd=$tool_cmd"
    continue
  fi
  log "found in QMAKEPATH: $tool_cmd"
  echo "$tool_cmd"
  exit
done <<< "$instloc_prefix:$QMAKEPATH:" # append : to path to also read last item
log "not found ${tool_relpath@Q} in instloc_prefix=$instloc_prefix or QMAKEPATH=$QMAKEPATH"

#log "trying PATH ..."
if tool_cmd=$(command -v "$tool_name"); then
  log "found in PATH: $tool_cmd"
    echo "$tool_cmd"
    exit
fi
log "not found ${tool_name@Q} in PATH=${PATH@Q}"

log "not found, giving up. hint: set env: $tool_cmd_env=/absolute/path/to/$tool_name"
