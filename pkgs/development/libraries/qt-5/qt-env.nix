{ lib, runCommand, lndir, qtbase }: name: paths:

runCommand name { qtbase = qtbase.dev; paths = lib.chooseDevOutputs paths;  } ''

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

for pkg in $paths $qtbase; do
    if [[ -d "$pkg/mkspecs" ]]; then
        ${lndir}/bin/lndir -silent "$pkg/mkspecs" "$out/mkspecs"

        for dir in bin include lib share; do
            if [[ -d "$pkg/$dir" ]]; then
                ${lndir}/bin/lndir -silent "$pkg/$dir" "$out/$dir"
            fi
        done
    fi
done
''
