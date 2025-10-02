addGuileLibPath () {
    if test -d "$1/share/guile/site/@version@"; then
        addToSearchPath GUILE_LOAD_PATH "$1/share/guile/site/@version@"
        addToSearchPath GUILE_LOAD_COMPILED_PATH "$1/share/guile/site/@version@"
        addToSearchPath GUILE_EXTENSIONS_PATH "$1/share/guile/site/@version@"
    elif test -d "$1/share/guile/site"; then
        addToSearchPath GUILE_LOAD_PATH "$1/share/guile/site"
        addToSearchPath GUILE_LOAD_COMPILED_PATH "$1/share/guile/site"
        addToSearchPath GUILE_EXTENSIONS_PATH "$1/share/guile/site"
    fi

    if test -d "$1/lib/guile/@version@/ccache"; then
        addToSearchPath GUILE_LOAD_COMPILED_PATH "$1/lib/guile/@version@/ccache"
    fi

    if test -d "$1/lib/guile/@version@/site-ccache"; then
        addToSearchPath GUILE_LOAD_COMPILED_PATH "$1/lib/guile/@version@/site-ccache"
    fi

    if test -d "$1/lib/guile/@version@/extensions"; then
        addToSearchPath GUILE_EXTENSIONS_PATH "$1/lib/guile/@version@/extensions"
    fi
}

addEnvHooks "$hostOffset" addGuileLibPath
