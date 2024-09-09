# shellcheck shell=bash

fixupOutputHooks+=(_gtkCleanImmodulesCache)

# Clean comments that link to generator of the file
_gtkCleanImmodulesCache() {
    # gtk_module_path is where the modules are installed
    # https://gitlab.gnome.org/GNOME/gtk/-/blob/3.24.24/gtk/gtkmodules.c#L68
    # gtk_binary_version can be retrived with:
    # pkg-config --variable=gtk_binary_version gtk+-3.0
    local f="${prefix:?}/lib/@gtk_module_path@/@gtk_binary_version@/immodules.cache"
    if [ -f "$f" ]; then
        sed 's|Created by .*bin/gtk-query-|Created by bin/gtk-query-|' -i "$f"
    fi
}
