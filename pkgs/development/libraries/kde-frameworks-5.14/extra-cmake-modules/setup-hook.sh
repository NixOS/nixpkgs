makeKDEWrapper() {
    KSERVICE_BUILD_KDESYCOCA=${KDESYCOCA:+1}
    local old="$1"
    local new="$2"
    shift
    shift
    makeQtWrapper "$old" "$new" ${KDESYCOCA:+--set KDESYCOCA "$KDESYCOCA"} "$@"
}

wrapKDEProgram() {
    KSERVICE_BUILD_KDESYCOCA=${KDESYCOCA:+1}
    local prog="$1"
    shift
    wrapQtProgram "$prog" ${KDESYCOCA:+--set KDESYCOCA "$KDESYCOCA"} "$@"
}
