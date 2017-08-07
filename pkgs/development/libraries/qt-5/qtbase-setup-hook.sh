qtPluginPrefix=@qtPluginPrefix@
qtQmlPrefix=@qtQmlPrefix@
qtDocPrefix=@qtDocPrefix@

NIX_QT5_MODULES="${NIX_QT5_MODULES}${NIX_QT5_MODULES:+:}@out@"
NIX_QT5_MODULES_DEV="${NIX_QT5_MODULES_DEV}${NIX_QT5_MODULES_DEV:+:}@dev@"

providesQtRuntime() {
    [ -d "$1/$qtPluginPrefix" ] || [ -d "$1/$qtQmlPrefix" ]
}

# Propagate any runtime dependency of the building package.
# Each dependency is propagated to the user environment and as a build
# input so that it will be re-propagated to the user environment by any
# package depending on the building package. (This is necessary in case
# the building package does not provide runtime dependencies itself and so
# would not be propagated to the user environment.)
_qtCrossEnvHook() {
    if providesQtRuntime "$1"; then
        propagatedBuildInputs+=" $1"
        propagatedUserEnvPkgs+=" $1"
    fi
}
if [ -z "$NIX_QT5_TMP" ]; then
    crossEnvHooks+=(_qtCrossEnvHook)
fi

_qtEnvHook() {
    if providesQtRuntime "$1"; then
        propagatedNativeBuildInputs+=" $1"
        if [ -z "$crossConfig" ]; then
        propagatedUserEnvPkgs+=" $1"
        fi
    fi
}
if [ -z "$NIX_QT5_TMP" ]; then
    envHooks+=(_qtEnvHook)
fi

_qtPreFixupHook() {
    moveToOutput "mkspecs" "${!outputDev}"
}
if [ -z "$NIX_QT5_TMP" ]; then
    preFixupHooks+=(_qtPreFixupHook)
fi

_qtPostInstallHook() {
    # Clean up temporary installation files created by this setup hook.
    # For building Qt modules, this is necessary to prevent including
    # dependencies in the output. For all other packages, this is necessary
    # to induce patchelf to remove the temporary paths from the RPATH of
    # dynamically-linked objects.
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

    # Patch CMake modules
    if [ -n "$NIX_QT_SUBMODULE" ]; then
        find "${!outputLib}" -name "*.cmake" | while read file; do
            substituteInPlace "$file" \
                --subst-var-by NIX_OUT "${!outputLib}" \
                --subst-var-by NIX_DEV "${!outputDev}" \
                --subst-var-by NIX_BIN "${!outputBin}"
        done
    fi
}
if [ -z "$NIX_QT5_TMP" ]; then
    preConfigureHooks+=(_qtPreConfigureHook)
fi

_qtLinkModuleDir() {
    if [ -d "$1/$2" ]; then
        @lndir@/bin/lndir -silent "$1/$2" "$NIX_QT5_TMP/$2"
        find "$1/$2" -printf "$2/%P\n" >> "$NIX_QT5_TMP/nix-support/qt-inputs"
    fi
}

_qtPreConfigureHook() {
    # Find the temporary qmake executable first.
    # This must run after all the environment hooks!
    export PATH="$NIX_QT5_TMP/bin${PATH:+:}$PATH"

    # Link all runtime module dependencies into the temporary directory.
    IFS=: read -a modules <<< $NIX_QT5_MODULES
    for module in ${modules[@]}; do
        _qtLinkModuleDir "$module" "lib"
    done

    # Link all the build-time module dependencies into the temporary directory.
    IFS=: read -a modules <<< $NIX_QT5_MODULES_DEV
    for module in ${modules[@]}; do
        _qtLinkModuleDir "$module" "bin"
        _qtLinkModuleDir "$module" "include"
        _qtLinkModuleDir "$module" "lib"
        _qtLinkModuleDir "$module" "mkspecs"
        _qtLinkModuleDir "$module" "share"
    done
}
if [ -z "$NIX_QT5_TMP" ]; then
    postInstallHooks+=(_qtPostInstallHook)
fi

if [ -z "$NIX_QT5_TMP" ]; then
    if [ -z "$NIX_QT_SUBMODULE" ]; then
        if [ -z "$IN_NIX_SHELL" ]; then
            NIX_QT5_TMP=$(pwd)/__nix_qt5__
        else
            NIX_QT5_TMP=$(mktemp -d)
        fi
    else
        NIX_QT5_TMP=$out
    fi

    mkdir -p "$NIX_QT5_TMP/nix-support"
    for subdir in bin include lib mkspecs share; do
        mkdir "$NIX_QT5_TMP/$subdir"
        echo "$subdir/" >> "$NIX_QT5_TMP/nix-support/qt-inputs"
    done

    cp "@dev@/bin/qmake" "$NIX_QT5_TMP/bin"
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
fi

