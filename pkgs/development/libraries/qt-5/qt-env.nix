{ runCommand, lndir }:

{ paths, qtbase }:

runCommand "qt-env" { inherit paths qtbase; } ''

mkdir -p "$out/bin" "$out/mkspecs" "$out/include" "$out/lib" "$out/share"

cp "$qtbase/bin/qmake" "$out/bin"
cat >"$out/bin/qt.conf" <<EOF
[Paths]
Prefix = $out
Plugins = lib/qt5/plugins
Imports = lib/qt5/imports
Qml2Imports = lib/qt5/qml
Documentation = share/doc/qt5
EOF

for path in $paths; do
    if [[ -d "$path/mkspecs" ]]; then
        ${lndir}/bin/lndir -silent "$path/mkspecs" "$out/mkspecs"

        for dir in bin include lib share; do
            if [[ -d "$path/$dir" ]]; then
                ${lndir}/bin/lndir -silent "$path/$dir" "$out/$dir"
            fi
        done
    fi
done

''
