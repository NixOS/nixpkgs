addGstreamer1LibPath () {
    if test -d "$1/lib/gstreamer-1.0"
    then
        addToSearchPath GST_PLUGIN_SYSTEM_PATH_1_0 "$1/lib/gstreamer-1.0"
    fi
}

addEnvHooks "$hostOffset" addGstreamer1LibPath
