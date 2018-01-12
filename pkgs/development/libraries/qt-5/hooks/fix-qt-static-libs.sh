# fixQtStaticLibs
#
# Usage: fixQtStaticLibs _lib_ _dev_
#
# Find static Qt libraries in output _lib_ and move them to the corresponding
# path in output _dev_. Any QMake library definitions (*.prl files) are also
# moved and library paths are patched.
#
fixQtStaticLibs() {
    local lib="$1"
    local dev="$2"

    pushd "$lib"
    if [ -d "lib" ]; then
        find lib \( -name '*.a' -o -name '*.la' -o -name '*.prl' \) -print0 | \
            while read -r -d $'\0' file; do
                mkdir -p "$dev/$(dirname "$file")"
                mv "$lib/$file" "$dev/$file"
            done
    fi
    popd

    if [ -d "$dev" ]; then
        find "$dev" -name '*.prl' | while read prl; do
            echo "fixQtStaticLibs: Fixing built-in paths in \`$prl'..."
            sed -i "$prl" \
                -e '/^QMAKE_PRL_BUILD_DIR =/d' \
                -e '/^QMAKE_PRO_INPUT =/d' \
                -e "s|-L\\\$\\\$NIX_OUTPUT_OUT/lib|-L$lib/lib -L$dev/lib|g"
        done
    fi
}
