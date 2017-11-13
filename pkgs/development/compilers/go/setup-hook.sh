addToGoPath() {
    prependToSearchPath GOPATH "$1/share/go"
}

envHooks+=(addToGoPath)
