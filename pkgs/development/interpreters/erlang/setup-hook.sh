addErlangLibPath() {
    prependToSearchPath ERL_LIBS $1/lib/erlang/lib
}

envHooks+=(addErlangLibPath)
