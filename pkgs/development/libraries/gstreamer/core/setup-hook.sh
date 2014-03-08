addGstreamerLibPath () {
    if test -d "$1/lib/gstreamer-1.0"
    then
        export GST_PLUGIN_SYSTEM_PATH_1_0="${GST_PLUGIN_SYSTEM_PATH_1_0}${GST_PLUGIN_SYSTEM_PATH_1_0:+:}$1/lib/gstreamer-1.0"
    fi
}

envHooks=(${envHooks[@]} addGstreamerLibPath)

