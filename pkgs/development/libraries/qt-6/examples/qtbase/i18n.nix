{ lib
, stdenv
, qtbase
, qmake
, qttools
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "qtbase-example-i18n";
  # src is a tar.xz file
  inherit (qtbase) version src;
  prePatch = ''
    cd examples/widgets/tools/i18n
  '';
  # fix default install location: ${qtbase.out}/examples/
  installPhase = ''
    runHook preInstall
    install -Dm 555 i18n $out/bin/i18n
    runHook postInstall
  '';
  nativeBuildInputs = [
    qmake
    qttools
    wrapQtAppsHook
  ];
  buildInputs = [
    qtbase
  ];
}
