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

mkdir -p "$qtOut/bin" "$qtOut/mkspecs" "$qtOut/include" "$qtOut/nix-support" "$qtOut/lib"

cp "@out@/bin/qmake" "$qtOut/bin"
cat >"$qtOut/bin/qt.conf" <<EOF
[Paths]
Prefix = $qtOut
Plugins = lib/qt5/plugins
Imports = lib/qt5/imports
Qml2Imports = lib/qt5/qml
EOF
export QMAKE="$qtOut/bin/qmake"

envHooks+=(addQtModule)
preConfigurePhases+=" setQMakePath"
