{ buildEnv, qtbase }: name: paths:

buildEnv {
  inherit name;
  paths = [ qtbase ] ++ paths;

  pathsToLink = [ "/metatypes" "/bin" "/mkspecs" "/include" "/lib" "/share" "/libexec" ];
  extraOutputsToInstall = [ "out" "dev" ];

  postBuild = ''
    for f in qmake qmake6; do
      rm "$out/bin/$f"
      cp "${qtbase}/bin/$f" "$out/bin"
    done
    cat >"$out/bin/qt.conf" <<EOF
    [Paths]
    Prefix = $out
    Plugins = ${qtbase.qtPluginPrefix}
    Qml2Imports = ${qtbase.qtQmlPrefix}
    EOF
  '';
}
