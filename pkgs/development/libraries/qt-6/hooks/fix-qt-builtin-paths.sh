# fixQtBuiltinPaths
#
# Usage: fixQtBuiltinPaths _dir_ _pattern_
#
# Fix Qt builtin paths in files matching _pattern_ under _dir_.
#
fixQtBuiltinPaths() {
    local dir="$1"
    local pattern="$2"
    local lib="${!outputLib}"

    if [ -d "$dir" ]; then
        find "$dir" -name "$pattern" | while read pr_; do
            if grep -q '\$\$\[QT_' "${pr_:?}"; then
                echo "fixQtBuiltinPaths: Fixing Qt builtin paths in \`${pr_:?}'..."
                sed -i "${pr_:?}" \
                    -e "s|\\\$\\\$\\[QT_HOST_BINS[^]]*\\]|$lib/bin|g" \
                    -e "s|\\\$\\\$\\[QT_HOST_LIBEXECS[^]]*\\]|$lib/libexec|g" \
                    -e "s|\\\$\\\$\\[QT_HOST_DATA[^]]*\\]/mkspecs|$lib/mkspecs|g" \
                    -e "s|\\\$\\\$\\[QT_HOST_PREFIX[^]]*\\]|$lib|g" \
                    -e "s|\\\$\\\$\\[QT_INSTALL_ARCHDATA[^]]*\\]|$lib|g" \
                    -e "s|\\\$\\\$\\[QT_INSTALL_BINS[^]]*\\]|$lib/bin|g" \
                    -e "s|\\\$\\\$\\[QT_INSTALL_CONFIGURATION[^]]*\\]|$lib|g" \
                    -e "s|\\\$\\\$\\[QT_INSTALL_DATA[^]]*\\]|$lib|g" \
                    -e "s|\\\$\\\$\\[QT_INSTALL_DOCS[^]]*\\]|$lib/share/doc|g" \
                    -e "s|\\\$\\\$\\[QT_INSTALL_EXAMPLES[^]]*\\]|$lib/examples|g" \
                    -e "s|\\\$\\\$\\[QT_INSTALL_HEADERS[^]]*\\]|$lib/include|g" \
                    -e "s|\\\$\\\$\\[QT_INSTALL_LIBS[^]]*\\]|$lib/lib|g" \
                    -e "s|\\\$\\\$\\[QT_INSTALL_LIBEXECS[^]]*\\]|$lib/libexec|g" \
                    -e "s|\\\$\\\$\\[QT_INSTALL_PLUGINS[^]]*\\]|$lib/$qtPluginPrefix|g" \
                    -e "s|\\\$\\\$\\[QT_INSTALL_PREFIX[^]]*\\]|$lib|g" \
                    -e "s|\\\$\\\$\\[QT_INSTALL_TESTS[^]]*\\]|$lib/tests|g" \
                    -e "s|\\\$\\\$\\[QT_INSTALL_TRANSLATIONS[^]]*\\]|$lib/translations|g" \
                    -e "s|\\\$\\\$\\[QT_INSTALL_QML[^]]*\\]|$lib/$qtQmlPrefix|g"
            fi
        done
    elif [ -e "$dir" ]; then
        if grep -q '\$\$\[QT_' "${dir:?}"; then
            echo "fixQtBuiltinPaths: Fixing Qt builtin paths in \`${dir:?}'..."
            sed -i "${dir:?}" \
                -e "s|\\\$\\\$\\[QT_HOST_BINS[^]]*\\]|$lib/bin|g" \
                -e "s|\\\$\\\$\\[QT_HOST_LIBEXECS[^]]*\\]|$lib/libexec|g" \
                -e "s|\\\$\\\$\\[QT_HOST_DATA[^]]*\\]/mkspecs|$lib/mkspecs|g" \
                -e "s|\\\$\\\$\\[QT_HOST_PREFIX[^]]*\\]|$lib|g" \
                -e "s|\\\$\\\$\\[QT_INSTALL_ARCHDATA[^]]*\\]|$lib|g" \
                -e "s|\\\$\\\$\\[QT_INSTALL_BINS[^]]*\\]|$lib/bin|g" \
                -e "s|\\\$\\\$\\[QT_INSTALL_CONFIGURATION[^]]*\\]|$lib|g" \
                -e "s|\\\$\\\$\\[QT_INSTALL_DATA[^]]*\\]|$lib|g" \
                -e "s|\\\$\\\$\\[QT_INSTALL_DOCS[^]]*\\]|$lib/share/doc|g" \
                -e "s|\\\$\\\$\\[QT_INSTALL_EXAMPLES[^]]*\\]|$lib/examples|g" \
                -e "s|\\\$\\\$\\[QT_INSTALL_HEADERS[^]]*\\]|$lib/include|g" \
                -e "s|\\\$\\\$\\[QT_INSTALL_LIBS[^]]*\\]|$lib/lib|g" \
                -e "s|\\\$\\\$\\[QT_INSTALL_LIBEXECS[^]]*\\]|$lib/libexec|g" \
                -e "s|\\\$\\\$\\[QT_INSTALL_PLUGINS[^]]*\\]|$lib/$qtPluginPrefix|g" \
                -e "s|\\\$\\\$\\[QT_INSTALL_PREFIX[^]]*\\]|$lib|g" \
                -e "s|\\\$\\\$\\[QT_INSTALL_TESTS[^]]*\\]|$lib/tests|g" \
                -e "s|\\\$\\\$\\[QT_INSTALL_TRANSLATIONS[^]]*\\]|$lib/translations|g" \
                -e "s|\\\$\\\$\\[QT_INSTALL_QML[^]]*\\]|$lib/$qtQmlPrefix|g"
        fi
    else
        echo "fixQtBuiltinPaths: Warning: \`$dir' does not exist"
    fi
}
