#! @shell@
# shellcheck shell=bash

COMMAND=$1
shift
exec @hoogle@/bin/hoogle "$COMMAND" --database @out@/share/doc/hoogle/default.hoo "$@"
