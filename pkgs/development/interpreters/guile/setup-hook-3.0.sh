addGuileLibPath () {
    if test -d "$1/share/guile/site/3.0"; then
        addToSearchPath GUILE_LOAD_PATH "$1/share/guile/site/3.0"
        addToSearchPath GUILE_LOAD_COMPILED_PATH "$1/share/guile/site/3.0"
        addToSearchPath GUILE_EXTENSIONS_PATH "$1/share/guile/site/3.0"
    elif test -d "$1/share/guile/site"; then
        addToSearchPath GUILE_LOAD_PATH "$1/share/guile/site"
        addToSearchPath GUILE_LOAD_COMPILED_PATH "$1/share/guile/site"
        addToSearchPath GUILE_EXTENSIONS_PATH "$1/share/guile/site"
    fi

    if test -d "$1/lib/guile/3.0/ccache"; then
        addToSearchPath GUILE_LOAD_COMPILED_PATH "$1/lib/guile/3.0/ccache"
    fi

    if test -d "$1/lib/guile/3.0/site-ccache"; then
        addToSearchPath GUILE_LOAD_COMPILED_PATH "$1/lib/guile/3.0/site-ccache"
    fi

    if test -d "$1/lib/guile/3.0/extensions"; then
        addToSearchPath GUILE_EXTENSIONS_PATH "$1/lib/guile/3.0/extensions"
    fi
}

addEnvHooks "$hostOffset" addGuileLibPath
