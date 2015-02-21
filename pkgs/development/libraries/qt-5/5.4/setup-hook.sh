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

        if [[ -n $qtSubmodule ]] && [[ -d "$1/lib" ]]; then
            @lndir@/bin/lndir -silent "$1/lib" "$qtOut/lib"
            find "$1/lib" -printf 'lib/%P\n' >> "$qtOut/nix-support/qt-inputs"
        fi

        propagatedBuildInputs+=" $1"
    fi

    if [[ -f "$1/bin/qmake" ]]; then
        addToSearchPath PATH "$qtOut/bin"
    fi

    if [[ -d "$1/lib/qt5/qml" ]] || [[ -d "$1/lib/qt5/plugins" ]] || [[ -d "$1/lib/qt5/imports" ]]; then
        propagatedUserEnvPkgs+=" $1"
    fi
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
Plugins = $qtOut/lib/qt5/plugins
Imports = $qtOut/lib/qt5/imports
Qml2Imports = $qtOut/lib/qt5/qml
EOF

envHooks+=(addQtModule)
