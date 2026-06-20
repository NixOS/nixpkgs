unpackCmdHooks+=(_tryUnpackDmg)
_tryUnpackDmg() {
    if ! [[ "$curSrc" =~ \.dmg$ ]]; then return 1; fi
    undmg "$curSrc"
}
