makeKDEWrapper() {
    local old="$1"
    local new="$2"
    shift
    shift
    if [[ -z "$KDE_WRAPPER_IMPURE" ]]; then
        KSERVICE_BUILD_KDESYCOCA=${KDESYCOCA:+1}
        makeQtWrapper "$old" "$new" ${KDESYCOCA:+--set KDESYCOCA "$KDESYCOCA"} "$@"
    else
        makeQtWrapper "$old" "$new" "$@"
    fi
}

wrapKDEProgram() {
    local prog="$1"
    shift
    if [[ -z "$KDE_WRAPPER_IMPURE" ]]; then
        KSERVICE_BUILD_KDESYCOCA=${KDESYCOCA:+1}
        wrapQtProgram "$prog" ${KDESYCOCA:+--set KDESYCOCA "$KDESYCOCA"} "$@"
    else
        wrapQtProgram "$prog" "$@"
    fi
}
