addErlangLibPath() {
    addToSearchPath ERL_LIBS $1/lib/erlang/lib
}

addEnvHooks "$hostOffset" addErlangLibPath
