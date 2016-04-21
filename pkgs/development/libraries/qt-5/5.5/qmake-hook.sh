if [[ -z "$QMAKE" ]]; then

_qtLinkDependencyDir() {
    @lndir@/bin/lndir -silent "$1/$2" "$qtOut/$2"
    if [ -n "$NIX_QT_SUBMODULE" ]; then
        find "$1/$2" -printf "$2/%P\n" >> "$out/nix-support/qt-inputs"
    fi
}

_qtLinkModule() {
    if [ -d "$1/mkspecs" ]; then
        # $1 is a Qt module
        _qtLinkDependencyDir "$1" mkspecs

        for dir in bin include lib share; do
            if [ -d "$1/$dir" ]; then
                _qtLinkDependencyDir "$1" "$dir"
            fi
        done
    fi
}

_qtRmModules() {
    cat "$out/nix-support/qt-inputs" | while read file; do
      if [ -h "$out/$file" ]; then
        rm "$out/$file"
      fi
    done

    cat "$out/nix-support/qt-inputs" | while read file; do
      if [ -d "$out/$file" ]; then
        rmdir --ignore-fail-on-non-empty -p "$out/$file"
      fi
    done

    rm "$out/nix-support/qt-inputs"
}

_qtRmQmake() {
    rm "$qtOut/bin/qmake" "$qtOut/bin/qt.conf"
}

_qtSetQmakePath() {
    export PATH="$qtOut/bin${PATH:+:}$PATH"
}

_qtMultioutModuleDevs() {
    # We cannot simply set these paths in configureFlags because libQtCore retains
    # references to the paths it was built with.
    moveToOutput "bin" "${!outputDev}"
    moveToOutput "include" "${!outputDev}"

    # The destination directory must exist or moveToOutput will do nothing
    mkdir -p "${!outputDev}/share"
    moveToOutput "share/doc" "${!outputDev}"
}

qmakeConfigurePhase() {
    runHook preConfigure

    qmake PREFIX=$out $qmakeFlags

    runHook postConfigure
}

qtOut=""
if [[ -z "$NIX_QT_SUBMODULE" ]]; then
    qtOut=`mktemp -d`
else
    qtOut=$out
fi

mkdir -p "$qtOut/bin" "$qtOut/mkspecs" "$qtOut/include" "$qtOut/nix-support" "$qtOut/lib" "$qtOut/share"

cp "@qt_dev@/bin/qmake" "$qtOut/bin"
cat >"$qtOut/bin/qt.conf" <<EOF
[Paths]
Prefix = $qtOut
Plugins = lib/qt5/plugins
Imports = lib/qt5/imports
Qml2Imports = lib/qt5/qml
Documentation = share/doc/qt5
EOF

export QMAKE="$qtOut/bin/qmake"

envHooks+=(_qtLinkModule)
# Set PATH to find qmake first in a preConfigure hook
# It must run after all the envHooks!
postHooks+=(_qtSetQmakePath)

if [ -z "$dontUseQmakeConfigure" -a -z "$configurePhase" ]; then
    configurePhase=qmakeConfigurePhase
fi

if [ -n "$NIX_QT_SUBMODULE" ]; then
    postInstallHooks+=(_qtRmQmake _qtRmModules)
    preFixupHooks+=(_qtMultioutModuleDevs)
fi

fi
