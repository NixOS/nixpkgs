{ mkDerivation
, fetchFromGitHub
, cmake
, qtbase
, qtdeclarative
, qt3d
, openimageio2
}:

mkDerivation rec {
  pname = "QtOIIO";
  version = "2022.10.31";
  src = fetchFromGitHub {
    owner = "alicevision";
    repo = "QtOIIO";
    rev = "a41dae9c2688277b600e73376146eb26afc671f5";
    sha256 = "/422K75v51aKfGV2DSs/+jekbwyJyNStVyjU2CwmncA=";
  };
  dontWrapQtApps = true;
  nativeBuildInputs = [
    cmake
  ];
  buildInputs = [
    qtdeclarative
    qt3d
    openimageio2
  ];
  postInstall = ''
    mkdir -p $out/${qtbase.qtQmlPrefix}
    mv $out/qml/* $out/${qtbase.qtQmlPrefix}
    mv $out/imageformats $out/lib
    rmdir $out/qml
  '';
}
