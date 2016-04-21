addToSearchPathOnceWithCustomDelimiter() {
    local delim="$1"
    local search="$2"
    local target="$3"
    local dirs
    local exported
    IFS="$delim" read -a dirs <<< "${!search}"
    local canonical
    if canonical=$(readlink -e "$target"); then
        for dir in ${dirs[@]}; do
            if [ "z$dir" == "z$canonical" ]; then exported=1; fi
        done
        if [ -z $exported ]; then
            eval "export ${search}=\"${!search}${!search:+$delim}$canonical\""
        fi
    fi
}

addToSearchPathOnce() {
    addToSearchPathOnceWithCustomDelimiter ':' "$@"
}

propagateOnce() {
    addToSearchPathOnceWithCustomDelimiter ' ' "$@"
}

_qtPropagateRuntimeDependencies() {
    for dir in "lib/qt5/plugins" "lib/qt5/qml" "lib/qt5/imports"; do
        if [ -d "$1/$dir" ]; then
            propagateOnce propagatedBuildInputs "$1"
            propagateOnce propagatedUserEnvPkgs "$1"
            break
        fi
    done
    addToSearchPathOnce QT_PLUGIN_PATH "$1/lib/qt5/plugins"
    addToSearchPathOnce QML_IMPORT_PATH "$1/lib/qt5/imports"
    addToSearchPathOnce QML2_IMPORT_PATH "$1/lib/qt5/qml"
}

envHooks+=(_qtPropagateRuntimeDependencies)

_qtMultioutDevs() {
    # This is necessary whether the package is a Qt module or not
    moveToOutput "mkspecs" "${!outputDev}"
}

preFixupHooks+=(_qtMultioutDevs)

if [[ -z "$NIX_QT_PIC" ]]; then
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE${NIX_CFLAGS_COMPILE:+ }-fPIC"
    export NIX_QT_PIC=1
fi
