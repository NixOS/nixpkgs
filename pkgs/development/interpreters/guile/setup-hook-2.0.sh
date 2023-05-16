addGuileLibPath () {
    if test -d "$1/share/guile/site/2.0"; then
<<<<<<< HEAD
        addToSearchPath GUILE_LOAD_PATH "$1/share/guile/site/2.0"
        addToSearchPath GUILE_LOAD_COMPILED_PATH "$1/share/guile/site/2.0"
    elif test -d "$1/share/guile/site"; then
        addToSearchPath GUILE_LOAD_PATH "$1/share/guile/site"
        addToSearchPath GUILE_LOAD_COMPILED_PATH "$1/share/guile/site"
    fi

    if test -d "$1/lib/guile/2.0/ccache"; then
        addToSearchPath GUILE_LOAD_COMPILED_PATH "$1/lib/guile/2.0/ccache"
    fi

    if test -d "$1/lib/guile/2.0/site-ccache"; then
        addToSearchPath GUILE_LOAD_COMPILED_PATH "$1/lib/guile/2.0/site-ccache"
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fi
}

addEnvHooks "$hostOffset" addGuileLibPath
