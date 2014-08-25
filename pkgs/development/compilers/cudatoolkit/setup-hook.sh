addIncludePath () {
    if test -d "$1/usr_include"
    then
        export NIX_CFLAGS_COMPILE="${NIX_CFLAGS_COMPILE} -I$1/usr_include"
    fi
}

envHooks=(${envHooks[@]} addIncludePath)
