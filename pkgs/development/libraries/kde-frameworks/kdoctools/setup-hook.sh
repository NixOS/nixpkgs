addXdgData() {
    prependToSearchPath XDG_DATA_DIRS "$1/share"
}

envHooks+=(addXdgData)
