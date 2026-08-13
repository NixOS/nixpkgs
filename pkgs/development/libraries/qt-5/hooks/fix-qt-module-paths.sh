# fixQtModulePaths
#
# Usage: fixQtModulePaths _dir_
#
# Find Qt module definitions in directory _dir_ and patch the module paths.
#
fixQtModulePaths () {
    local dir="$1"
    local bin="${!outputBin}"
    local dev="${!outputDev}"
    local lib="${!outputLib}"

    if [ -d "$dir" ]; then
        find "$dir" -name 'qt_*.pri' | while read pr; do
            if grep -q '\$\$QT_MODULE_' "${pr:?}"; then
                echo "fixQtModulePaths: Fixing module paths in \`${pr:?}'..."
                sed -i "${pr:?}" \
                    -e "s|\\\$\\\$QT_MODULE_LIB_BASE|$lib/lib|g" \
                    -e "s|\\\$\\\$QT_MODULE_HOST_LIB_BASE|$lib/lib|g" \
                    -e "s|\\\$\\\$QT_MODULE_INCLUDE_BASE|$dev/include|g" \
                    -e "s|\\\$\\\$QT_MODULE_BIN_BASE|$dev/bin|g"
            fi
        done
    elif [ -e "$dir" ]; then
        echo "fixQtModulePaths: Warning: \`$dir' is not a directory"
    else
        echo "fixQtModulePaths: Warning: \`$dir' does not exist"
    fi

    if [ "z$bin" != "z$dev" ]; then
        if [ -d "$bin/bin" ]; then
            mkdir -p "$dev/bin"
            lndir -silent "$bin/bin" "$dev/bin"
        fi
    fi
}
