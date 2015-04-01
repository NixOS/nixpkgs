#! @shell@

COMMAND=$1
shift
HOOGLE_DOC_PATH=@out@/share/hoogle/doc exec @hoogle@/bin/hoogle \
    "$COMMAND" -d @out@/share/hoogle "$@"
