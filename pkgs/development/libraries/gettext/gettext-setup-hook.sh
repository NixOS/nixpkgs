gettextDataDirsHook() {
    if [ -d "$1/share/gettext" ]; then
        addToSearchPath GETTEXTDATADIRS "$1/share/gettext"
    fi
}

addEnvHooks "$hostOffset" gettextDataDirsHook
