findGdkPixbufLoaders() {

    local loadersCache="$1/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache"
    if [[ -f "$loadersCache" ]]; then
        if [[ -f "${GDK_PIXBUF_MODULE_FILE-}" ]]; then
            export GDK_PIXBUF_MODULE_FILE="$loadersCache":$GDK_PIXBUF_MODULE_FILE
        else
            export GDK_PIXBUF_MODULE_FILE="$loadersCache"
        fi
    fi

}

addEnvHooks "$targetOffset" findGdkPixbufLoaders
