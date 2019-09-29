# shellcheck shell=bash

# Populate XDG_ICON_DIRS
hicolorIconThemeHook() {

    # where to find icon themes
    if [ -d "$1/share/icons" ]; then
      addToSearchPath XDG_ICON_DIRS "$1/share"
    fi
}

# I think this is meant to be a runtime dep
addEnvHooks "${hostOffset:?}" hicolorIconThemeHook
