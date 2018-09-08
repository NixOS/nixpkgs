addGuileLibPath () {
    local ver=2.2
    if [[ -d "$1/share/guile/site/$ver" ]]; then
        addToSearchPath GUILE_LOAD_PATH "$1/share/guile/site/$ver"
    elif [[ -d "$1/share/guile/site" ]]; then
        addToSearchPath GUILE_LOAD_PATH "$1/share/guile/site"
    fi

    if [[ -d "$1/lib/guile/$ver/site-ccache" ]]; then
        addToSearchPath GUILE_LOAD_COMPILED_PATH "$1/lib/guile/$ver/site-ccache"
    fi
}

addEnvHooks "$hostOffset" addGuileLibPath
