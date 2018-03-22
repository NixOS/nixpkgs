addErlLibPath() {
    addToSearchPath ERL_LIBS $1/lib/elixir/lib
}

addEnvHooks "$hostOffset" addErlLibPath
