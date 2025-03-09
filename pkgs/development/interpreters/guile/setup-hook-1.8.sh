addGuileLibPath () {
    if test -d "$1/share/guile/site"; then
        appendToSearchPath GUILE_LOAD_PATH "$1/share/guile/site"
    fi
}

addEnvHooks "$hostOffset" addGuileLibPath
