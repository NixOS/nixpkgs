addGstreamerLibPath () {
    prependToSearchPathWithCustomDelimiter GST_PLUGIN_SYSTEM_PATH "$1/lib/gstreamer-0.10"
}

envHooks+=(addGstreamerLibPath)
