make_gtk_applications_find_icon_themes() {

    # where to find icon themes
    if [ -d "$1/share/icons" ]; then
      addToSearchPath XDG_ICON_DIRS $1/share
    fi
	
}

envHooks+=(make_gtk_applications_find_icon_themes)
