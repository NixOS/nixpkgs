addQtDependency() {
    addToSearchPath QT_PLUGIN_PATH "$1/lib/qt5/plugins"
    addToSearchPath QML_IMPORT_PATH "$1/lib/qt5/imports"
    addToSearchPath QML2_IMPORT_PATH "$1/lib/qt5/qml"
    addToSearchPath XDG_DATA_DIRS "$1/share"
}

wrapQtProgram() {
    local prog="$1"
    shift
    if [[ -n "$QT_WRAPPER_IMPURE" ]]; then
        wrapProgram "$prog" \
            --prefix QT_PLUGIN_PATH : "$QT_PLUGIN_PATH" \
            --prefix QML_IMPORT_PATH : "$QML_IMPORT_PATH" \
            --prefix QML2_IMPORT_PATH : "$QML2_IMPORT_PATH" \
            "$@"
    else
        wrapProgram "$prog" \
            --set QT_PLUGIN_PATH "$QT_PLUGIN_PATH" \
            --set QML_IMPORT_PATH "$QML_IMPORT_PATH" \
            --set QML2_IMPORT_PATH "$QML2_IMPORT_PATH" \
            "$@"
    fi
}

makeQtWrapper() {
    local old="$1"
    local new="$2"
    shift
    shift
    if [[ -n "$QT_WRAPPER_IMPURE" ]]; then
        makeWrapper "$old" "$new" \
            --prefix QT_PLUGIN_PATH : "$QT_PLUGIN_PATH" \
            --prefix QML_IMPORT_PATH : "$QML_IMPORT_PATH" \
            --prefix QML2_IMPORT_PATH : "$QML2_IMPORT_PATH" \
            "$@"
    else
        makeWrapper "$old" "$new" \
            --set QT_PLUGIN_PATH "$QT_PLUGIN_PATH" \
            --set QML_IMPORT_PATH "$QML_IMPORT_PATH" \
            --set QML2_IMPORT_PATH "$QML2_IMPORT_PATH" \
            "$@"
    fi
}

# cannot use addToSearchPath because these directories may not exist yet
export QT_PLUGIN_PATH="$QT_PLUGIN_PATH${QT_PLUGIN_PATH:+:}$out/lib/qt5/plugins"
export QML_IMPORT_PATH="$QML_IMPORT_PATH${QML_IMPORT_PATH:+:}$out/lib/qt5/imports"
export QML2_IMPORT_PATH="$QML2_IMPORT_PATH${QML2_IMPORT_PATH:+:}$out/lib/qt5/qml"
export XDG_DATA_DIRS="$XDG_DATA_DIRS${XDG_DATA_DIRS:+:}$out/share"

envHooks+=(addQtDependency)
