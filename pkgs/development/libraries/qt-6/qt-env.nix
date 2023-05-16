{ buildEnv, qtbase }: name: paths:

buildEnv {
  inherit name;
  paths = [ qtbase ] ++ paths;

  pathsToLink = [ "/bin" "/mkspecs" "/include" "/lib" "/share" "/libexec" ];
  extraOutputsToInstall = [ "out" "dev" ];

  postBuild = ''
<<<<<<< HEAD
    for f in qmake qmake6; do
      rm "$out/bin/$f"
      cp "${qtbase}/bin/$f" "$out/bin"
    done
=======
    rm "$out/bin/qmake"
    cp "${qtbase}/bin/qmake" "$out/bin"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    cat >"$out/bin/qt.conf" <<EOF
    [Paths]
    Prefix = $out
    Plugins = ${qtbase.qtPluginPrefix}
    Qml2Imports = ${qtbase.qtQmlPrefix}
    EOF
  '';
}
