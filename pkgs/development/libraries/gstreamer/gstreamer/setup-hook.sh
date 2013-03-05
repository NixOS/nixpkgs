addGstreamerLibPath () {
    # 
    if test -d "$1/lib/gstreamer-*"
    then
        export GST_PLUGIN_PATH="${GST_PLUGIN_PATH}${GST_PLUGIN_PATH:+:}$1/lib/gstreamer-*"
    fi
}

envHooks=(${envHooks[@]} addGstreamerLibPath)
