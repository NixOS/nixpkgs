fixQtModuleCMakeConfig() {
    local module="$1"
    sed -e "/set(imported_location/ s@\\\${_qt5${module}_install_prefix}@${!outputLib}@" \
        -i "${!outputDev}/lib/cmake/Qt5${module}/Qt5${module}Config.cmake"
}
