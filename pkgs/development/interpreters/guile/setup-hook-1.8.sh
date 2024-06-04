addGuileLibPath () {
    if test -d "$1/share/guile/site"; then
        addToSearchPath GUILE_LOAD_PATH "$1/share/guile/site"
    fi
}

addEnvHooks "$hostOffset" addGuileLibPath
