#! @shell@

COMMAND=$1
shift
exec @hoogle@/bin/hoogle "$COMMAND" --database @database@ "$@"
