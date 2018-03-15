gettextDataDirsHook() {
    if [ -d "$1/share/gettext" ]; then
        addToSearchPath GETTEXTDATADIRS "$1/share/gettext"
    fi
}

addEnvHooks "$hostOffset" gettextDataDirsHook

# libintl must be listed in load flags on non-Glibc
# it doesn't hurt to have it in Glibc either though
gettextLdflags() {
    export NIX_LDFLAGS="$NIX_LDFLAGS -lintl"
}

if [ ! -z "@gettextNeedsLdflags@" ]; then
    addEnvHooks "$hostOffset" gettextLdflags
fi
