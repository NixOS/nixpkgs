fixupOutputHooks+=(_gtk2CleanComments)

# Clean comments that link to generator of the file
_gtk2CleanComments() {
    local f="$prefix/lib/gtk-2.0/2.10.0/immodules.cache"
    if [ -f "$f" ]; then
        sed 's|Created by .*bin/gtk-query-|Created by bin/gtk-query-|' -i "$f"
    fi
}

