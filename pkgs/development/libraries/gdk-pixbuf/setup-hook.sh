findGdkPixbufLoaders() {

	if [ -n "$out" ] && [ -z "$IN_NIX_SHELL" ]; then

		# set pixbuf loaders.cache for this package

		local loadersDir="$out/lib/gdk-pixbuf-loaders-2.0/$name"
		mkdir -p "$loadersDir"
		
		if [ -f "$1/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache" ]; then
			cat "$1/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache" >> "$loadersDir/loaders.cache"
		fi
	
		if [ -f "$1/lib/gdk-pixbuf/loaders.cache" ]; then
			cat "$1/lib/gdk-pixbuf/loaders.cache" >> "$loadersDir/loaders.cache"
		fi
		
		# note, this is not a search path
		export GDK_PIXBUF_MODULE_FILE=$(readlink -e "$loadersDir/loaders.cache")

	fi

}

envHooks+=(findGdkPixbufLoaders)
