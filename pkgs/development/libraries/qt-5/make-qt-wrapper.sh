wrapQtProgram() {
    local prog="$1"
    shift
    wrapProgram "$prog" \
        --set QT_PLUGIN_PATH "$QT_PLUGIN_PATH" \
        --set QML_IMPORT_PATH "$QML_IMPORT_PATH" \
        --set QML2_IMPORT_PATH "$QML2_IMPORT_PATH" \
        --prefix XDG_DATA_DIRS : "$RUNTIME_XDG_DATA_DIRS" \
        --prefix XDG_CONFIG_DIRS : "$RUNTIME_XDG_CONFIG_DIRS" \
        --prefix GIO_EXTRA_MODULES : "$GIO_EXTRA_MODULES" \
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
        --prefix GIO_EXTRA_MODULES : "$GIO_EXTRA_MODULES" \
        "$@"
}

_makeQtWrapperSetup() {
    # cannot use addToSearchPath because these directories may not exist yet
    export QT_PLUGIN_PATH="$QT_PLUGIN_PATH${QT_PLUGIN_PATH:+:}${!outputLib}/lib/qt5/plugins"
    export QML_IMPORT_PATH="$QML_IMPORT_PATH${QML_IMPORT_PATH:+:}${!outputLib}/lib/qt5/imports"
    export QML2_IMPORT_PATH="$QML2_IMPORT_PATH${QML2_IMPORT_PATH:+:}${!outputLib}/lib/qt5/qml"
    export RUNTIME_XDG_DATA_DIRS="$RUNTIME_XDG_DATA_DIRS${RUNTIME_XDG_DATA_DIRS:+:}${!outputBin}/share${GSETTINGS_SCHEMAS_PATH:+:$GSETTINGS_SCHEMAS_PATH}"
    export RUNTIME_XDG_CONFIG_DIRS="$RUNTIME_XDG_CONFIG_DIRS${RUNTIME_XDG_CONFIG_DIRS:+:}${!outputBin}/etc/xdg"
}

prePhases+=(_makeQtWrapperSetup)

_findGioModules() {
    if [ -d "$1"/lib/gio/modules ] && [ -n "$(ls -A $1/lib/gio/modules)" ] ; then
        export GIO_EXTRA_MODULES="$GIO_EXTRA_MODULES${GIO_EXTRA_MODULES:+:}$1/lib/gio/modules"
    fi
}

envHooks+=(_findGioModules)
