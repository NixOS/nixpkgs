# shellcheck shell=bash

fixupOutputHooks+=(_gtk4CleanComments)

# Clean comments that link to generator of the file
_gtk4CleanComments() {
    local f="${prefix:?}/lib/gtk-4.0/4.0.0/immodules.cache"
    if [ -f "$f" ]; then
        sed 's|Created by .*bin/gtk-query-|Created by bin/gtk-query-|' -i "$f"
    fi
}
