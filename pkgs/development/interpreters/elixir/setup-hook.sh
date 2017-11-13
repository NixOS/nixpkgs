addErlLibPath() {
    prependToSearchPath ERL_LIBS $1/lib/elixir/lib
}

envHooks+=(addErlLibPath)
