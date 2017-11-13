addGstreamer1LibPath () {
    prependToSearchPathWithCustomDelimiter ' ' GST_PLUGIN_SYSTEM_PATH_1_0 "$1/lib/gstreamer-1.0"
}

envHooks+=(addGstreamer1LibPath)

