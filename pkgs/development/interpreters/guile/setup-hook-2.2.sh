addGuileLibPath () {
    if test -d "$1/share/guile/site/2.2"; then
        addToSearchPath GUILE_LOAD_PATH "$1/share/guile/site/2.2"
        addToSearchPath GUILE_LOAD_COMPILED_PATH "$1/share/guile/site/2.2"
    elif test -d "$1/share/guile/site"; then
        addToSearchPath GUILE_LOAD_PATH "$1/share/guile/site"
        addToSearchPath GUILE_LOAD_COMPILED_PATH "$1/share/guile/site"
    fi

    if test -d "$1/lib/guile/2.2/ccache"; then
        addToSearchPath GUILE_LOAD_COMPILED_PATH "$1/lib/guile/2.2/ccache"
    fi

    if test -d "$1/lib/guile/2.2/site-ccache"; then
        addToSearchPath GUILE_LOAD_COMPILED_PATH "$1/lib/guile/2.2/site-ccache"
    fi
}

addEnvHooks "$hostOffset" addGuileLibPath
