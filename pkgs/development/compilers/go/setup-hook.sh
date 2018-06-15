addToGoPath() {
    addToSearchPath GOPATH $1/share/go
}

addEnvHooks "$targetOffset" addToGoPath
