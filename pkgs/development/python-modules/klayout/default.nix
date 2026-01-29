{
  buildPythonPackage,
  curl,
  cython,
  expat,
  fetchFromGitHub,
  lib,
  libpng,
  qt6,
  setuptools,
  which,
  zlib,
}:

buildPythonPackage rec {
  pname = "klayout";
  version = "0.30.5";

  src = fetchFromGitHub {
    owner = "KLayout";
    repo = "klayout";
    rev = "v${version}";
    hash = "sha256-R41xsowPaSG2r2jiMcj0RGdxfFD8jT+atie24xxicb4=";
  };

  nativeBuildInputs = [
    setuptools
    qt6.wrapQtAppsHook
    which
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qtmultimedia
    libpng
    curl
    expat
    zlib
  ];

  preBuild = ''
    export KLAYOUT_QT_VERSION=6
    export HAVE_QT6=1
    export HAVE_PNG=1
    export HAVE_CURL=1
    export HAVE_EXPAT=1
    export HAVE_ZLIB=1
  '';

  format = "setuptools";

  meta = with lib; {
    description = "KLayout’s Python API";
    homepage = "https://github.com/KLayout/klayout";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fbeffa ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
