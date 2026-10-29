# fixQtBuiltinPaths
#
# Usage: fixQtBuiltinPaths _dir_ _pattern_
#
# Fix Qt builtin paths in files matching _pattern_ under _dir_.
#
fixQtBuiltinPaths() {
    local dir="$1"
    local pattern="$2"
    local bin="${!outputBin}"
    local dev="${!outputDev}"
    local doc="${!outputDoc}"
    local lib="${!outputLib}"

    if [ -d "$dir" ]; then
        find "$dir" -name "$pattern" | while read pr_; do
            if grep -q '\$\$\[QT_' "${pr_:?}"; then
                echo "fixQtBuiltinPaths: Fixing Qt builtin paths in \`${pr_:?}'..."
                sed -i "${pr_:?}" \
                    -e "s|\\\$\\\$\\[QT_HOST_BINS[^]]*\\]|"'$$'"NIX_OUTPUT_DEV/bin|g" \
                    -e "s|\\\$\\\$\\[QT_HOST_DATA[^]]*\\]/mkspecs|$dev/mkspecs|g" \
                    -e "s|\\\$\\\$\\[QT_HOST_PREFIX[^]]*\\]|"'$$'"NIX_OUTPUT_DEV|g" \
                    -e "s|\\\$\\\$\\[QT_INSTALL_ARCHDATA[^]]*\\]|$lib|g" \
                    -e "s|\\\$\\\$\\[QT_INSTALL_BINS[^]]*\\]|$bin/bin|g" \
                    -e "s|\\\$\\\$\\[QT_INSTALL_CONFIGURATION[^]]*\\]|$bin|g" \
                    -e "s|\\\$\\\$\\[QT_INSTALL_DATA[^]]*\\]|$lib|g" \
                    -e "s|\\\$\\\$\\[QT_INSTALL_DOCS[^]]*\\]|$doc/share/doc|g" \
                    -e "s|\\\$\\\$\\[QT_INSTALL_EXAMPLES[^]]*\\]|$doc/examples|g" \
                    -e "s|\\\$\\\$\\[QT_INSTALL_HEADERS[^]]*\\]|$dev/include|g" \
                    -e "s|\\\$\\\$\\[QT_INSTALL_LIBS[^]]*\\]|$lib/lib|g" \
                    -e "s|\\\$\\\$\\[QT_INSTALL_LIBEXECS[^]]*\\]|$lib/libexec|g" \
                    -e "s|\\\$\\\$\\[QT_INSTALL_PLUGINS[^]]*\\]|$bin/$qtPluginPrefix|g" \
                    -e "s|\\\$\\\$\\[QT_INSTALL_PREFIX[^]]*\\]|"'$$'"NIX_OUTPUT_LIB|g" \
                    -e "s|\\\$\\\$\\[QT_INSTALL_TESTS[^]]*\\]|$dev/tests|g" \
                    -e "s|\\\$\\\$\\[QT_INSTALL_TRANSLATIONS[^]]*\\]|$lib/translations|g" \
                    -e "s|\\\$\\\$\\[QT_INSTALL_QML[^]]*\\]|$bin/$qtQmlPrefix|g"
            fi
        done
    elif [ -e "$dir" ]; then
        if grep -q '\$\$\[QT_' "${dir:?}"; then
            echo "fixQtBuiltinPaths: Fixing Qt builtin paths in \`${dir:?}'..."
            sed -i "${dir:?}" \
                -e "s|\\\$\\\$\\[QT_HOST_BINS[^]]*\\]|"'$$'"NIX_OUTPUT_DEV/bin|g" \
                -e "s|\\\$\\\$\\[QT_HOST_DATA[^]]*\\]/mkspecs|$dev/mkspecs|g" \
                -e "s|\\\$\\\$\\[QT_HOST_PREFIX[^]]*\\]|"'$$'"NIX_OUTPUT_DEV|g" \
                -e "s|\\\$\\\$\\[QT_INSTALL_ARCHDATA[^]]*\\]|$lib|g" \
                -e "s|\\\$\\\$\\[QT_INSTALL_BINS[^]]*\\]|$bin/bin|g" \
                -e "s|\\\$\\\$\\[QT_INSTALL_CONFIGURATION[^]]*\\]|$bin|g" \
                -e "s|\\\$\\\$\\[QT_INSTALL_DATA[^]]*\\]|$lib|g" \
                -e "s|\\\$\\\$\\[QT_INSTALL_DOCS[^]]*\\]|$doc/share/doc|g" \
                -e "s|\\\$\\\$\\[QT_INSTALL_EXAMPLES[^]]*\\]|$doc/examples|g" \
                -e "s|\\\$\\\$\\[QT_INSTALL_HEADERS[^]]*\\]|$dev/include|g" \
                -e "s|\\\$\\\$\\[QT_INSTALL_LIBS[^]]*\\]|$lib/lib|g" \
                -e "s|\\\$\\\$\\[QT_INSTALL_LIBEXECS[^]]*\\]|$lib/libexec|g" \
                -e "s|\\\$\\\$\\[QT_INSTALL_PLUGINS[^]]*\\]|$bin/$qtPluginPrefix|g" \
                -e "s|\\\$\\\$\\[QT_INSTALL_PREFIX[^]]*\\]|"'$$'"NIX_OUTPUT_LIB|g" \
                -e "s|\\\$\\\$\\[QT_INSTALL_TESTS[^]]*\\]|$dev/tests|g" \
                -e "s|\\\$\\\$\\[QT_INSTALL_TRANSLATIONS[^]]*\\]|$lib/translations|g" \
                -e "s|\\\$\\\$\\[QT_INSTALL_QML[^]]*\\]|$bin/$qtQmlPrefix|g"
        fi
    else
        echo "fixQtBuiltinPaths: Warning: \`$dir' does not exist"
    fi
}
