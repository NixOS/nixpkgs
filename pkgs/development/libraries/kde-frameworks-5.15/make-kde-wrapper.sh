makeKDEWrapper() {
    local old="$1"
    local new="$2"
    shift
    shift
    makeQtWrapper "$old" "$new" "$@"
}

wrapKDEProgram() {
    local prog="$1"
    shift
    wrapQtProgram "$prog" "$@"
}
