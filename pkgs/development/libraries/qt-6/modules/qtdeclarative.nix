{ qtModule
, qtbase
, qtshadertools
, openssl
, python3
}:

qtModule {
  pname = "qtdeclarative";
  qtInputs = [ qtbase qtshadertools ];
  propagatedBuildInputs = [ openssl python3 ];
  preConfigure = ''
    export LD_LIBRARY_PATH="$PWD/build/lib''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"
  '';
  postInstall = ''
    substituteInPlace "$out/lib/cmake/Qt6Qml/Qt6QmlMacros.cmake" \
      --replace ''\'''${QT6_INSTALL_PREFIX}' "$out"
  '';
}
