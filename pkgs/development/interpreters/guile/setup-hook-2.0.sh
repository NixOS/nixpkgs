addGuileLibPath () {
    if test -d "$1/share/guile/site/2.0"; then
        export GUILE_LOAD_PATH="${GUILE_LOAD_PATH-}${GUILE_LOAD_PATH:+:}$1/share/guile/site/2.0"
        export GUILE_LOAD_COMPILED_PATH="${GUILE_LOAD_COMPILED_PATH-}${GUILE_LOAD_COMPILED_PATH:+:}$1/share/guile/site/2.0"
    elif test -d "$1/share/guile/site"; then
        export GUILE_LOAD_PATH="${GUILE_LOAD_PATH-}${GUILE_LOAD_PATH:+:}$1/share/guile/site"
        export GUILE_LOAD_COMPILED_PATH="${GUILE_LOAD_COMPILED_PATH-}${GUILE_LOAD_COMPILED_PATH:+:}$1/share/guile/site"
    fi

    if test -d "$1/lib/guile/2.0/ccache"; then
        export GUILE_LOAD_COMPILED_PATH="${GUILE_LOAD_COMPILED_PATH-}${GUILE_LOAD_COMPILED_PATH:+:}$1/lib/guile/2.0/ccache"
    fi

    if test -d "$1/lib/guile/2.0/site-ccache"; then
        export GUILE_LOAD_COMPILED_PATH="${GUILE_LOAD_COMPILED_PATH-}${GUILE_LOAD_COMPILED_PATH:+:}$1/lib/guile/2.0/site-ccache"
    fi
}

addEnvHooks "$hostOffset" addGuileLibPath
