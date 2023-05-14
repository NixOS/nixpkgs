{ buildEnv, qtbase }: name: paths:

buildEnv {
  inherit name;
  paths = [ qtbase ] ++ paths;

  pathsToLink = [ "/bin" "/mkspecs" "/include" "/lib" "/share" "/libexec" ];
  extraOutputsToInstall = [ "out" "dev" ];

  postBuild = ''
    rm "$out/bin/qmake"
    cp "${qtbase}/bin/qmake" "$out/bin"
    cat >"$out/bin/qt.conf" <<EOF
    [Paths]
    Prefix = $out
    Plugins = ${qtbase.qtPluginPrefix}
    Qml2Imports = ${qtbase.qtQmlPrefix}
    EOF
  '';
}
