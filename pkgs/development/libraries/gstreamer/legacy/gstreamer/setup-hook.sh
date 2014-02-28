addGstreamerLibPath () {
    if test -d "$1/lib/gstreamer-0.10"
    then
        export GST_PLUGIN_SYSTEM_PATH="${GST_PLUGIN_SYSTEM_PATH}${GST_PLUGIN_SYSTEM_PATH:+:}$1/lib/gstreamer-0.10"
    fi
}

envHooks=(${envHooks[@]} addGstreamerLibPath)
