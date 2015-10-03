addQtModule() {
    if [[ -d "$1/mkspecs" ]]; then

        @lndir@/bin/lndir -silent "$1/mkspecs" "$qtOut/mkspecs"
        if [[ -n $qtSubmodule ]]; then
            find "$1/mkspecs" -printf 'mkspecs/%P\n' >> "$qtOut/nix-support/qt-inputs"
        fi

        if [[ -d "$1/bin" ]]; then
            @lndir@/bin/lndir -silent "$1/bin" "$qtOut/bin"
            if [[ -n $qtSubmodule ]]; then
                find "$1/bin" -printf 'bin/%P\n' >> "$qtOut/nix-support/qt-inputs"
            fi
        fi

        if [[ -d "$1/include" ]]; then
            @lndir@/bin/lndir -silent "$1/include" "$qtOut/include"
            if [[ -n $qtSubmodule ]]; then
                find "$1/include" -printf 'include/%P\n' >> "$qtOut/nix-support/qt-inputs"
            fi
        fi

        if [[ -d "$1/lib" ]]; then
            @lndir@/bin/lndir -silent "$1/lib" "$qtOut/lib"
            if [[ -n $qtSubmodule ]]; then
                find "$1/lib" -printf 'lib/%P\n' >> "$qtOut/nix-support/qt-inputs"
            fi

            if [[ -d "$1/lib/qt5/plugins" ]]; then
                QT_PLUGIN_PATH="$QT_PLUGIN_PATH${QT_PLUGIN_PATH:+:}$1/lib/qt5/plugins";
            fi

            if [[ -d "$1/lib/qt5/imports" ]]; then
                QML_IMPORT_PATH="$QML_IMPORT_PATH${QML_IMPORT_PATH:+:}$1/lib/qt5/imports";
            fi

            if [[ -d "$1/lib/qt5/qml" ]]; then
                QML2_IMPORT_PATH="$QML2_IMPORT_PATH${QML2_IMPORT_PATH:+:}$1/lib/qt5/qml";
            fi
        fi

        if [[ -d "$1/share" ]]; then
            @lndir@/bin/lndir -silent "$1/share" "$qtOut/share"
            if [[ -n $qtSubmodule ]]; then
                find "$1/share" -printf 'share/%P\n' >> "$qtOut/nix-support/qt-inputs"
            fi
        fi
    fi
}

setQMakePath() {
    export PATH="$qtOut/bin${PATH:+:}$PATH"
}

qtOut=""
if [[ -z $qtSubmodule ]]; then
    qtOut="$PWD/qmake-$name"
else
    qtOut=$out
fi

mkdir -p "$qtOut/bin" "$qtOut/mkspecs" "$qtOut/include" \
         "$qtOut/nix-support" "$qtOut/lib" "$qtOut/share"

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

envHooks+=(addQtModule)
preConfigurePhases+=" setQMakePath"
