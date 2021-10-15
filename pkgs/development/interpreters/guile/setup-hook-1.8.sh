addGuileLibPath () {
    if test -d "$1/share/guile/site"; then
        export GUILE_LOAD_PATH="${GUILE_LOAD_PATH-}${GUILE_LOAD_PATH:+:}$1/share/guile/site"
    fi
}

addEnvHooks "$hostOffset" addGuileLibPath
