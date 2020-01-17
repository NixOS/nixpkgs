findGdkPixbufLoaders() {

	# choose the longest loaders.cache
	local loadersCache="$1/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache"
	if [[ -f "$loadersCache" ]]; then
		if [[ -f "${GDK_PIXBUF_MODULE_FILE-}" ]]; then
			if (( "$(cat "$loadersCache" | wc -l)" > "$(cat "$GDK_PIXBUF_MODULE_FILE" | wc -l)" )); then
				export GDK_PIXBUF_MODULE_FILE="$loadersCache"
			fi
		else
			export GDK_PIXBUF_MODULE_FILE="$loadersCache"
		fi
	fi

}

addEnvHooks "$hostOffset" findGdkPixbufLoaders
