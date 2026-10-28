unpackCmdHooks+=(_tryUnar)
_tryUnar() {
    if ! [[ "$curSrc" =~ \.rar$ ]]; then return 1; fi
    unar "$curSrc" >/dev/null
}
