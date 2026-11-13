unpackCmdHooks+=(_tryUnrarFree)
_tryUnrarFree() {
    if ! [[ "$curSrc" =~ \.rar$ ]]; then return 1; fi
    unrar-free -x "$curSrc" >/dev/null
}
