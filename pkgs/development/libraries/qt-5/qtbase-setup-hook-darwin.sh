qtPluginPrefix=@qtPluginPrefix@
qtQmlPrefix=@qtQmlPrefix@
qtDocPrefix=@qtDocPrefix@

_qtRmCMakeLink() {
    find "${!outputLib}" -name "*.cmake" -type l | xargs rm
}

postInstallHooks+=(_qtRmCMakeLink)

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

_qtPropagate() {
    for dir in $qtPluginPrefix $qtQmlPrefix; do
        if [ -d "$1/$dir" ]; then
            propagateOnce propagatedBuildInputs "$1"
            break
        fi
    done
    addToSearchPathOnce QT_PLUGIN_PATH "$1/$qtPluginPrefix"
    addToSearchPathOnce QML2_IMPORT_PATH "$1/$qtQmlPrefix"
}

crossEnvHooks+=(_qtPropagate)

_qtPropagateNative() {
    for dir in $qtPluginPrefix $qtQmlPrefix; do
        if [ -d "$1/$dir" ]; then
            propagateOnce propagatedNativeBuildInputs "$1"
            break
        fi
    done
    if [ -z "$crossConfig" ]; then
    addToSearchPathOnce QT_PLUGIN_PATH "$1/$qtPluginPrefix"
    addToSearchPathOnce QML2_IMPORT_PATH "$1/$qtQmlPrefix"
    fi
}

envHooks+=(_qtPropagateNative)

_qtMultioutDevs() {
    # This is necessary whether the package is a Qt module or not
    moveToOutput "mkspecs" "${!outputDev}"
}

preFixupHooks+=(_qtMultioutDevs)

_qtSetCMakePrefix() {
    export CMAKE_PREFIX_PATH="$NIX_QT5_TMP${CMAKE_PREFIX_PATH:+:}${CMAKE_PREFIX_PATH}"
}

_qtRmTmp() {
    if [ -z "$NIX_QT_SUBMODULE" ]; then
        rm -fr "$NIX_QT5_TMP"
    else
        cat "$NIX_QT5_TMP/nix-support/qt-inputs" | while read file; do
            if [ ! -d "$NIX_QT5_TMP/$file" ]; then
                rm -f "$NIX_QT5_TMP/$file"
            fi
        done

        cat "$NIX_QT5_TMP/nix-support/qt-inputs" | while read dir; do
            if [ -d "$NIX_QT5_TMP/$dir" ]; then
                rmdir --ignore-fail-on-non-empty -p "$NIX_QT5_TMP/$dir"
            fi
        done

        rm "$NIX_QT5_TMP/nix-support/qt-inputs"
    fi
}

_qtSetQmakePath() {
    export PATH="$NIX_QT5_TMP/bin${PATH:+:}$PATH"
}

if [ -z "$NIX_QT5_TMP" ]; then
    if [ -z "$NIX_QT_SUBMODULE" ]; then
        NIX_QT5_TMP=$(pwd)/.nix_qt5
    else
        NIX_QT5_TMP=$out
    fi
    postInstallHooks+=(_qtRmTmp)

    mkdir -p "$NIX_QT5_TMP/nix-support"
    for subdir in bin include mkspecs share; do
        mkdir -p "$NIX_QT5_TMP/$subdir"
        echo "$subdir/" >> "$NIX_QT5_TMP/nix-support/qt-inputs"
    done
    mkdir -p "$NIX_QT5_TMP/lib"

    postHooks+=(_qtSetCMakePrefix)

    ln -sf "@dev@/bin/qmake" "$NIX_QT5_TMP/bin"
    echo "bin/qmake" >> "$NIX_QT5_TMP/nix-support/qt-inputs"

    cat >"$NIX_QT5_TMP/bin/qt.conf" <<EOF
[Paths]
Prefix = $NIX_QT5_TMP
Plugins = $qtPluginPrefix
Qml2Imports = $qtQmlPrefix
Documentation = $qtDocPrefix
EOF
    echo "bin/qt.conf" >> "$NIX_QT5_TMP/nix-support/qt-inputs"

    export QMAKE="$NIX_QT5_TMP/bin/qmake"

    # Set PATH to find qmake first in a preConfigure hook
    # It must run after all the envHooks!
    preConfigureHooks+=(_qtSetQmakePath)
fi

qt5LinkModuleDir() {
    if [ -d "$1/$2" ]; then
        @lndir@/bin/lndir -silent "$1/$2" "$NIX_QT5_TMP/$2"
        find "$1/$2" -printf "$2/%P\n" >> "$NIX_QT5_TMP/nix-support/qt-inputs"
    fi
}

qt5LinkDarwinModuleLibDir() {
  for fw in $(find "$1"/lib -maxdepth 1 -name '*.framework'); do
    if [ ! -L "$fw" ]; then
      ln -s "$fw" "$NIX_QT5_TMP"/lib
    fi
  done
  for file in $(find "$1"/lib -maxdepth 1 -type f); do
    if [ ! -L "$file" ]; then
      ln -s "$file" "$NIX_QT5_TMP"/lib
    fi
  done
  for dir in $(find "$1"/lib -maxdepth 1 -mindepth 1 -type d ! -name '*.framework'); do
      mkdir -p "$NIX_QT5_TMP"/lib/$(basename "$dir")
      @lndir@/bin/lndir -silent "$dir" "$NIX_QT5_TMP"/lib/$(basename "$dir")
  done
}

NIX_QT5_MODULES="${NIX_QT5_MODULES}${NIX_QT5_MODULES:+:}@out@"
NIX_QT5_MODULES_DEV="${NIX_QT5_MODULES_DEV}${NIX_QT5_MODULES_DEV:+:}@dev@"

_qtLinkAllModules() {
    IFS=: read -a modules <<< $NIX_QT5_MODULES
    for module in ${modules[@]}; do
        qt5LinkDarwinModuleLibDir "$module"
    done

    IFS=: read -a modules <<< $NIX_QT5_MODULES_DEV
    for module in ${modules[@]}; do
        qt5LinkModuleDir "$module" "bin"
        qt5LinkModuleDir "$module" "include"
        qt5LinkDarwinModuleLibDir "$module"
        qt5LinkModuleDir "$module" "mkspecs"
        qt5LinkModuleDir "$module" "share"
    done
}

preConfigureHooks+=(_qtLinkAllModules)

_qtFixCMakePaths() {
    find "${!outputLib}" -name "*.cmake" | while read file; do
        substituteInPlace "$file" \
            --subst-var-by NIX_OUT "${!outputLib}" \
            --subst-var-by NIX_DEV "${!outputDev}" \
            --subst-var-by NIX_BIN "${!outputBin}"
    done
}

if [ -n "$NIX_QT_SUBMODULE" ]; then
    postInstallHooks+=(_qtFixCMakePaths)
fi
