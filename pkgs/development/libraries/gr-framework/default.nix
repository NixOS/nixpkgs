{ lib
, stdenv
, fetchFromGitHub
, nix-update-script

, cairo
, cmake
, ffmpeg
, freetype
, ghostscript
, glfw
, libjpeg
, libtiff
, qhull
, qtbase
, wrapQtAppsHook
, xorg
, zeromq
}:

stdenv.mkDerivation rec {
  pname = "gr-framework";
  version = "0.72.10";

  src = fetchFromGitHub {
    owner = "sciapp";
    repo = "gr";
    rev = "v${version}";
    hash = "sha256-ZFaun8PBtPTmhZ0+OHzUu27NvcJGxsImh+c7ZvCTNa0=";
  };

  patches = [
    ./Use-the-module-mode-to-search-for-the-LibXml2-package.patch
  ];

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    cairo
    ffmpeg
    freetype
    ghostscript
    glfw
    libjpeg
    libtiff
    qhull
    qtbase
    xorg.libX11
    xorg.libXft
    xorg.libXt
    zeromq
  ];

  preConfigure = ''
    echo ${version} > version.txt
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GR framework is a graphics library for visualisation applications";
    homepage = "https://gr-framework.org";
    maintainers = [ lib.maintainers.paveloom ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
