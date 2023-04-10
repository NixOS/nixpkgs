{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, qtbase
, qtdeclarative
, qt3d
, ilmbase
, alembic
}:

mkDerivation rec {
  pname = "qmlAlembic";
  version = "2022.09.08";
  src = fetchFromGitHub {
    owner = "alicevision";
    repo = "qmlAlembic";
    rev = "896c52d88a9ef46b0d07eb42d11c631eda18d18c";
    sha256 = "cEqnZQsm6VwucYk6qD/mqXE7bsZz+KQwrTflvzslV50=";
  };
  dontWrapQtApps = true;
  nativeBuildInputs = [
    cmake
  ];
  buildInputs = [
    qtdeclarative
    qt3d
    ilmbase
    alembic
  ];
  postInstall = ''
    mkdir -p $out/${qtbase.qtQmlPrefix}
    mv $out/qml/* $out/${qtbase.qtQmlPrefix}
    rmdir $out/qml
  '';
}
