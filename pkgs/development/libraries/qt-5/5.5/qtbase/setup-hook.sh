if [[ -z "$QMAKE" ]]; then

linkDependencyDir() {
    @lndir@/bin/lndir -silent "$1/$2" "$qtOut/$2"
    if [[ -n "$NIX_QT_SUBMODULE" ]]; then
        find "$1/$2" -printf "$2/%P\n" >> "$out/nix-support/qt-inputs"
    fi
}

addQtModule() {
    if [[ -d "$1/mkspecs" ]]; then
        # $1 is a Qt module
        linkDependencyDir "$1" mkspecs

        for dir in bin include lib share; do
            if [[ -d "$1/$dir" ]]; then
                linkDependencyDir "$1" "$dir"
            fi
        done
    fi

    if [[ -d "$1/lib/qt5/plugins" ]]; then
        addToSearchPath QT_PLUGIN_PATH "$1/lib/qt5/plugins"
    fi

    if [[ -d "$1/lib/qt5/imports" ]]; then
        addToSearchPath QML_IMPORT_PATH "$1/lib/qt5/imports"
    fi

    if [[ -d "$1/lib/qt5/qml" ]]; then
        addToSearchPath QML2_IMPORT_PATH "$1/lib/qt5/qml"
    fi

    if [[ -d "$1/share" ]]; then
        addToSearchPath XDG_DATA_DIRS "$1/share"
    fi
}

rmQtModules() {
    cat "$out/nix-support/qt-inputs" | while read file; do
      if [[ -h "$out/$file" ]]; then
        rm "$out/$file"
      fi
    done

    cat "$out/nix-support/qt-inputs" | while read file; do
      if [[ -d "$out/$file" ]]; then
        rmdir --ignore-fail-on-non-empty -p "$out/$file"
      fi
    done

    rm "$out/nix-support/qt-inputs"
}

rmQMake() {
    rm "$qtOut/bin/qmake" "$qtOut/bin/qt.conf"
}

setQMakePath() {
    export PATH="$qtOut/bin${PATH:+:}$PATH"
}

wrapQtProgram() {
    wrapProgram "$1" \
        --set QT_PLUGIN_PATH : "$QT_PLUGIN_PATH" \
        --set QML_IMPORT_PATH : "$QML_IMPORT_PATH" \
        --set QML2_IMPORT_PATH : "$QML2_IMPORT_PATH" \
        "$@"
}

qtOut=""
if [[ -z "$NIX_QT_SUBMODULE" ]]; then
    qtOut="$PWD/qmake-$name"
else
    qtOut=$out
fi

mkdir -p "$qtOut/bin" "$qtOut/mkspecs" "$qtOut/include" "$qtOut/nix-support" "$qtOut/lib" "$qtOut/share"

cp "@out@/bin/qmake" "$qtOut/bin"
cat >"$qtOut/bin/qt.conf" <<EOF
[Paths]
Prefix = $qtOut
Plugins = lib/qt5/plugins
Imports = lib/qt5/imports
Qml2Imports = lib/qt5/qml
Documentation = share/doc/qt5
EOF

export QMAKE="$qtOut/bin/qmake"
addToSearchPath QT_PLUGIN_PATH "$out/lib/qt5/plugins"
addToSearchPath QML_IMPORT_PATH "$out/lib/qt5/imports"
addToSearchPath QML2_IMPORT_PATH "$out/lib/qt5/qml"
addToSearchPath XDG_DATA_DIRS "$out/share"

envHooks+=(addQtModule)
preConfigurePhases+=(setQMakePath)

if [[ -n "$NIX_QT_SUBMODULE" ]]; then
    preFixupPhases+=(rmQtModules)
    postPhases+=(rmQMake)
fi

fi

if [[ -z "$NIX_QT_PIC" ]]; then
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -fPIC"
    export NIX_QT_PIC=1
fi
