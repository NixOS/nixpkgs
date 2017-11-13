addGuileLibPath () {
    if test -d "$1/share/guile/site/2.0"
    then
        export GUILE_LOAD_PATH="$1/share/guile/site/2.0${GUILE_LOAD_PATH:+:}${GUILE_LOAD_PATH}"
        export GUILE_LOAD_COMPILED_PATH="$1/share/guile/site/2.0${GUILE_LOAD_COMPILED_PATH:+:}${GUILE_LOAD_COMPILED_PATH}"
    elif test -d "$1/share/guile/site"
    then
        export GUILE_LOAD_PATH="$1/share/guile/site${GUILE_LOAD_PATH:+:}${GUILE_LOAD_PATH}"
        export GUILE_LOAD_COMPILED_PATH="$1/share/guile/site${GUILE_LOAD_COMPILED_PATH:+:}${GUILE_LOAD_COMPILED_PATH}"
    fi
}

envHooks+=(addGuileLibPath)
