# shellcheck shell=bash

fixupOutputHooks+=(_gtk3CleanComments)

# Clean comments that link to generator of the file
_gtk3CleanComments() {
    local f="${prefix:?}/lib/gtk-3.0/3.0.0/immodules.cache"
    if [ -f "$f" ]; then
        sed 's|Created by .*bin/gtk-query-|Created by bin/gtk-query-|' -i "$f"
    fi
}
