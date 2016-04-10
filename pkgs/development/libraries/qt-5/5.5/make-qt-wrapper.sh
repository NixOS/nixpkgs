wrapQtProgram() {
    local prog="$1"
    shift
    wrapProgram "$prog" \
        --prefix QT_PLUGIN_PATH : "$QT_PLUGIN_PATH" \
        --prefix QML_IMPORT_PATH : "$QML_IMPORT_PATH" \
        --prefix QML2_IMPORT_PATH : "$QML2_IMPORT_PATH" \
        --prefix XDG_CONFIG_DIRS : "$NIX_WRAP_XDG_CONFIG_DIRS" \
        --prefix XDG_DATA_DIRS : "$NIX_WRAP_XDG_DATA_DIRS" \
        "$@"
}

makeQtWrapper() {
    local old="$1"
    local new="$2"
    shift
    shift
    makeWrapper "$old" "$new" \
        --prefix QT_PLUGIN_PATH : "$QT_PLUGIN_PATH" \
        --prefix QML_IMPORT_PATH : "$QML_IMPORT_PATH" \
        --prefix QML2_IMPORT_PATH : "$QML2_IMPORT_PATH" \
        --prefix XDG_CONFIG_DIRS : "$NIX_WRAP_XDG_CONFIG_DIRS" \
        --prefix XDG_DATA_DIRS : "$NIX_WRAP_XDG_DATA_DIRS" \
        "$@"
}

# cannot use addToSearchPath because these directories may not exist yet
export QT_PLUGIN_PATH="$QT_PLUGIN_PATH${QT_PLUGIN_PATH:+:}${!outputLib}/lib/qt5/plugins"
export QML_IMPORT_PATH="$QML_IMPORT_PATH${QML_IMPORT_PATH:+:}${!outputLib}/lib/qt5/imports"
export QML2_IMPORT_PATH="$QML2_IMPORT_PATH${QML2_IMPORT_PATH:+:}${!outputLib}/lib/qt5/qml"
export XDG_CONFIG_DIRS="$XDG_CONFIG_DIRS${XDG_CONFIG_DIRS:+:}${!outputLib}/etc/xdg"
export XDG_DATA_DIRS="$XDG_DATA_DIRS${XDG_DATA_DIRS:+:}${!outputLib}/share"
export NIX_WRAP_XDG_CONFIG_DIRS="$NIX_WRAP_XDG_CONFIG_DIRS${NIX_WRAP_XDG_CONFIG_DIRS:+:}${!outputLib}/etc/xdg"
export NIX_WRAP_XDG_DATA_DIRS="$NIX_WRAP_XDG_DATA_DIRS${NIX_WRAP_XDG_DATA_DIRS:+:}${!outputLib}/share"
