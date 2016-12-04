wrapQtProgram() {
    local prog="$1"
    shift
    wrapProgram "$prog" \
        --set QT_PLUGIN_PATH "$QT_PLUGIN_PATH" \
        --set QML_IMPORT_PATH "$QML_IMPORT_PATH" \
        --set QML2_IMPORT_PATH "$QML2_IMPORT_PATH" \
        --prefix XDG_DATA_DIRS : "$RUNTIME_XDG_DATA_DIRS" \
        --prefix XDG_CONFIG_DIRS : "$RUNTIME_XDG_CONFIG_DIRS" \
        "$@"
}

makeQtWrapper() {
    local old="$1"
    local new="$2"
    shift
    shift
    makeWrapper "$old" "$new" \
        --set QT_PLUGIN_PATH "$QT_PLUGIN_PATH" \
        --set QML_IMPORT_PATH "$QML_IMPORT_PATH" \
        --set QML2_IMPORT_PATH "$QML2_IMPORT_PATH" \
        --prefix XDG_DATA_DIRS : "$RUNTIME_XDG_DATA_DIRS" \
        --prefix XDG_CONFIG_DIRS : "$RUNTIME_XDG_CONFIG_DIRS" \
        "$@"
}

_makeQtWrapperSetup() {
    # cannot use addToSearchPath because these directories may not exist yet
    export QT_PLUGIN_PATH="$QT_PLUGIN_PATH${QT_PLUGIN_PATH:+:}${!outputLib}/lib/qt5/plugins"
    export QML_IMPORT_PATH="$QML_IMPORT_PATH${QML_IMPORT_PATH:+:}${!outputLib}/lib/qt5/imports"
    export QML2_IMPORT_PATH="$QML2_IMPORT_PATH${QML2_IMPORT_PATH:+:}${!outputLib}/lib/qt5/qml"
    export RUNTIME_XDG_DATA_DIRS="$XDG_DATA_DIRS${XDG_DATA_DIRS:+:}${!outputBin}/share"
    export RUNTIME_XDG_CONFIG_DIRS="$XDG_CONFIG_DIRS${XDG_CONFIG_DIRS:+:}${!outputBin}/etc/xdg"
}

prePhases+=(_makeQtWrapperSetup)
