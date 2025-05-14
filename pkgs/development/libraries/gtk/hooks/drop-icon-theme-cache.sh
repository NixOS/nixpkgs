# shellcheck shell=bash

# Packages often run gtk-update-icon-cache to include their icons in themes’ icon cache.
# However, since each package is installed to its own prefix, the files will only collide.
dropIconThemeCache() {
    if [[ -z "${dontDropIconThemeCache:-}" ]]; then
        local icondir="${out:?}/share/icons"
        if [[ -d "${icondir}" ]]; then
            # App icons are supposed to go to hicolor theme, since it is a fallback theme as per [icon-theme-spec], but some might still choose to install stylized icons to other themes.
            find "${icondir}" -name 'icon-theme.cache' -print0 \
              | while IFS= read -r -d '' file; do
                echo "Removing ${file}"
                rm -f "${file}"
            done
        fi
    fi
}

appendToVar preFixupPhases dropIconThemeCache
