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
  cmakeFlags = [
    "-DQT6_INSTALL_PREFIX=${placeholder "out"}"
    "-DQT_INSTALL_PREFIX=${placeholder "out"}"
  ];
  patches = [
    # prevent headaches from stale qmlcache data
    ../patches/qtdeclarative-default-disable-qmlcache.patch
  ];
  postInstall = ''
    substituteInPlace "$out/lib/cmake/Qt6Qml/Qt6QmlMacros.cmake" \
      --replace ''\'''${QT6_INSTALL_PREFIX}' "$dev"
  '';
  devTools = [
    "bin/qml"
    "bin/qmlcachegen"
    "bin/qmleasing"
    "bin/qmlimportscanner"
    "bin/qmllint"
    "bin/qmlmin"
    "bin/qmlplugindump"
    "bin/qmlprofiler"
    "bin/qmlscene"
    "bin/qmltestrunner"
  ];
}
