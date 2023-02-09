{ lib
, stdenv
, qtbase
, qtdeclarative
, qmake
, qttools
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "qtdeclarative-example-qml-i18n";
  # src is a tar.xz file
  inherit (qtdeclarative) version src;
  postPatch = ''
    cd examples/qml/qml-i18n
  '';
  # fix default install location: ${qtbase.out}/examples/
  installPhase = ''
    runHook preInstall
    install -Dm 555 qml-i18n $out/bin/qml-i18n
    runHook postInstall
  '';
  nativeBuildInputs = [
    qmake
    qttools
    wrapQtAppsHook
  ];
  buildInputs = [
    qtbase
    qtdeclarative
  ];
}
