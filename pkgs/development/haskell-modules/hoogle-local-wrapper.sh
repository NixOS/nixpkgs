#! @shell@

COMMAND=$1
shift
exec @hoogle@/bin/hoogle "$COMMAND" -d @out@/share/doc/hoogle "$@"
