{ mkDerivation
, fetchFromGitHub
, cmake
, qtbase
, qtdeclarative
, qtcharts
, boost
, coin-utils
, coin-clp
, coin-osi
, popsift
, alembic
, openimageio2
, ceres-solver
, opengv
, alicevision
}:

mkDerivation rec {
  pname = "QtAliceVision";
  version = "2022.06.03";
  src = fetchFromGitHub {
    owner = "alicevision";
    repo = "QtAliceVision";
    rev = "104d35444a29380c88d550d6b8065d4f855242f0";
    sha256 = "q6Vn6afMmCLqEgRplTW5mAFoX8AFIx0V8LAl45yc/Ho=";
  };
  dontWrapQtApps = true;
  nativeBuildInputs = [
    cmake
  ];
  buildInputs = [
    qtdeclarative
    qtcharts
    boost
    coin-utils
    coin-clp
    coin-osi
    popsift
    alembic
    openimageio2
    ceres-solver
    opengv
    alicevision
  ];
  postInstall = ''
    mkdir -p $out/${qtbase.qtQmlPrefix}
    mv $out/qml/* $out/${qtbase.qtQmlPrefix}
    rmdir $out/qml
  '';
}
