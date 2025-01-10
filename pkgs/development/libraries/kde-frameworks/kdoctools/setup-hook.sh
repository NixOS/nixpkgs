addXdgData() {
    addToSearchPath XDG_DATA_DIRS "$1/share"
}

addEnvHooks "$targetOffset" addXdgData
