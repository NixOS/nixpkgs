addGuileLibPath () {
    if test -d "$1/lib/site-guile"
    then
        export GUILE_LOAD_PATH="${GUILE_LOAD_PATH}${GUILE_LOAD_PATH:+:}$1/lib/site-guile"
    fi
}

envHooks=(${envHooks[@]} addGuileLibPath)
