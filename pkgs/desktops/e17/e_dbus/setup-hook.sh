addDbusIncludePath () {
    if test -d "$1/include/dbus-1.0"
    then
        export NIX_CFLAGS_COMPILE="${NIX_CFLAGS_COMPILE} -I$1/include/dbus-1.0 -I $1/lib/dbus-1.0/include"
    fi
}

envHooks+=(addDbusIncludePath)
