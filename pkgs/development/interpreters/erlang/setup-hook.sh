addErlangLibPath() {
    appendToSearchPath ERL_LIBS $1/lib/erlang/lib
}

envHooks+=(addErlangLibPath)
