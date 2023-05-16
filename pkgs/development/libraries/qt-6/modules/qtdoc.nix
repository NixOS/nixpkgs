{ qtModule
, qtdeclarative
<<<<<<< HEAD
, qtbase
, qttools
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

qtModule {
  pname = "qtdoc";
<<<<<<< HEAD
  # avoid fix-qt-builtin-paths hook substitute QT_INSTALL_DOCS to qtdoc's path
  postPatch = ''
    for file in $(grep -rl '$QT_INSTALL_DOCS'); do
      substituteInPlace $file \
          --replace '$QT_INSTALL_DOCS' "${qtbase}/share/doc"
    done
  '';
  nativeBuildInputs = [ (qttools.override { withClang = true; }) ];
  qtInputs = [ qtdeclarative ];
  cmakeFlags = [
    "-DCMAKE_MESSAGE_LOG_LEVEL=STATUS"
  ];
  dontUseNinjaBuild = true;
  buildFlags = [ "docs" ];
  dontUseNinjaInstall = true;
  installFlags = [ "install_docs" ];
=======
  qtInputs = [ qtdeclarative ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  outputs = [ "out" ];
}
