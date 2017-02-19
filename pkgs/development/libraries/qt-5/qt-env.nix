{ lib, buildEnv, qtbase }: name: paths:

buildEnv {
  inherit name;
  paths = [ qtbase ] ++ paths;

  pathsToLink = [ "/bin" "/mkspecs" "/include" "/lib" "/share" ];
  extraOutputsToInstall = [ "dev" ];

  postBuild = ''
    rm "$out/bin/qmake"
    cp "${qtbase.dev}/bin/qmake" "$out/bin"
    cat >"$out/bin/qt.conf" <<EOF
    [Paths]
    Prefix = $out
    Plugins = lib/qt5/plugins
    Imports = lib/qt5/imports
    Qml2Imports = lib/qt5/qml
    Documentation = share/doc/qt5
    EOF
  '';
}
