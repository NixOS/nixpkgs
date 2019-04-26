# Expose this, for example to use when generating wrappers.
export gdkPixbufModuleFileVar="@gdkPixbufModuleFileVar@"

findGdkPixbufLoaders() {

	# choose the longest loaders.cache
	local loadersCache="$1/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache"
	if [ -f "$loadersCache" ]; then
		if [ -f "${@gdkPixbufModuleFileVar@}" ]; then
			if [ $(cat "$loadersCache"|wc -l) -gt $(cat "$@gdkPixbufModuleFileVar@"|wc -l) ]; then
				export @gdkPixbufModuleFileVar@="$loadersCache"
			fi
		else
			export @gdkPixbufModuleFileVar@="$loadersCache"
		fi
	fi

}

addEnvHooks "$hostOffset" findGdkPixbufLoaders
