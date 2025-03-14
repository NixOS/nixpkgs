addGuileLibPath () {
    if test -d "$1/share/guile/site/3.0"; then
        appendToSearchPath GUILE_LOAD_PATH "$1/share/guile/site/3.0"
        appendToSearchPath GUILE_LOAD_COMPILED_PATH "$1/share/guile/site/3.0"
        appendToSearchPath GUILE_EXTENSIONS_PATH "$1/share/guile/site/3.0"
    elif test -d "$1/share/guile/site"; then
        appendToSearchPath GUILE_LOAD_PATH "$1/share/guile/site"
        appendToSearchPath GUILE_LOAD_COMPILED_PATH "$1/share/guile/site"
        appendToSearchPath GUILE_EXTENSIONS_PATH "$1/share/guile/site"
    fi

    if test -d "$1/lib/guile/3.0/ccache"; then
        appendToSearchPath GUILE_LOAD_COMPILED_PATH "$1/lib/guile/3.0/ccache"
    fi

    if test -d "$1/lib/guile/3.0/site-ccache"; then
        appendToSearchPath GUILE_LOAD_COMPILED_PATH "$1/lib/guile/3.0/site-ccache"
    fi

    if test -d "$1/lib/guile/3.0/extensions"; then
        appendToSearchPath GUILE_EXTENSIONS_PATH "$1/lib/guile/3.0/extensions"
    fi
}

addEnvHooks "$hostOffset" addGuileLibPath
