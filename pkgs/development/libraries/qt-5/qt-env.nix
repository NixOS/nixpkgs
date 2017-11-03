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
    Plugins = $qtPluginPrefix
    Qml2Imports = $qtQmlPrefix
    Documentation = $qtDocPrefix
    EOF
  '';
}
