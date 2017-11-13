addToGoPath() {
    appendToSearchPath GOPATH $1/share/go
}

envHooks=(${envHooks[@]} addToGoPath)
