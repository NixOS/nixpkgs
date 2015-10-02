wrapKDEProgram() {
    KSERVICE_BUILD_KDESYCOCA=${KDESYCOCA:+1}
    wrapQtProgram "$1" ${KDESYCOCA:+--set KDESYCOCA "$KDESYCOCA"} "$@"
}
