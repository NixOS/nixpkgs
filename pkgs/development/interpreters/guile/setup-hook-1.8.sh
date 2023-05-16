addGuileLibPath () {
    if test -d "$1/share/guile/site"; then
<<<<<<< HEAD
        addToSearchPath GUILE_LOAD_PATH "$1/share/guile/site"
=======
        export GUILE_LOAD_PATH="${GUILE_LOAD_PATH-}${GUILE_LOAD_PATH:+:}$1/share/guile/site"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fi
}

addEnvHooks "$hostOffset" addGuileLibPath
