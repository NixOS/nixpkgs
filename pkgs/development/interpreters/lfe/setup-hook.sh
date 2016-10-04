addLfeLibPath() {
    addToSearchPath ERL_LIBS $1/lib/lfe/lib
}

envHooks+=(addLfeLibPath)
