addGuileLibPath () {
    if test -d "$1/share/guile/site"
    then
        export GUILE_LOAD_PATH="${GUILE_LOAD_PATH}${GUILE_LOAD_PATH:+:}$1/share/guile/site"
    fi
    if test -d "$1/lib"
    then
        export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}${LD_LIBRARY_PATH:+:}$1/lib"
    fi
}

envHooks+=(addGuileLibPath)
