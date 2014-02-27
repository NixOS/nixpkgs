make_gtk_applications_find_pixbuf_loaders() {

    # set pixbuf loaders.cache for this package
	mkdir -p "$out/lib/$name/gdk-pixbuf"
	
	if [ -f "$1/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache" ]; then
		cat "$1/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache" >> "$out/lib/$name/gdk-pixbuf/loaders.cache"
	fi

	if [ -f "$1/lib/gdk-pixbuf/loaders.cache" ]; then
		cat "$1/lib/gdk-pixbuf/loaders.cache" >> "$out/lib/$name/gdk-pixbuf/loaders.cache"
	fi
	
	# note, this is not a search path
	export GDK_PIXBUF_MODULE_FILE=$(readlink -e "$out/lib/$name/gdk-pixbuf/loaders.cache")

}

envHooks+=(make_gtk_applications_find_pixbuf_loaders)
