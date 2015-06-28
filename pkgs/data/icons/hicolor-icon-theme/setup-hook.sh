# Populate XDG_ICON_DIRS
hicolorIconThemeHook() {

    # where to find icon themes
    if [ -d "$1/share/icons" ]; then
      addToSearchPath XDG_ICON_DIRS $1/share
    fi
	
}

envHooks+=(hicolorIconThemeHook)

# Remove icon cache
hicolorPreFixupPhase() {
    rm -f $out/share/icons/hicolor/icon-theme.cache
    rm -f $out/share/icons/HighContrast/icon-theme.cache
}

preFixupPhases="$preFixupPhases hicolorPreFixupPhase"

