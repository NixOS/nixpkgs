addGstreamerLibPath () {
    if test -d "$1/lib/gstreamer-1.0"
    then
        export GST_PLUGIN_PATH="${GST_PLUGIN_PATH}${GST_PLUGIN_PATH:+:}$1/lib/gstreamer-1.0"
    fi
}

envHooks=(${envHooks[@]} addGstreamerLibPath)
