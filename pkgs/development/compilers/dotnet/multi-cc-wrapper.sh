#!@runtimeShell@
set -x
set -eu

file=$(basename "$0")
tool=${file#multi-}

args=("$@")

prefix=""

while [[ $# > 0 ]] ; do
  case "$1" in
    -target)
      shift
      if [ -z "$1" ]; then
        echo "Error: -target requires an argument" >&2
        exit 1
      fi
      prefix=$1-
      ;;
    --target=*)
      prefix="${1#*=}"-
      ;;
  esac
  shift
done

exec "$prefix$tool" "${args[@]}"
