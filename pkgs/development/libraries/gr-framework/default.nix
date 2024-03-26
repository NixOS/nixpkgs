{ lib
, stdenv
, fetchFromGitHub
, nix-update-script

, cmake
, wrapQtAppsHook

, cairo
, ffmpeg
, freetype
, ghostscript
, glfw
, libjpeg
, libtiff
, qhull
, qtbase
, xorg
, zeromq
}:

stdenv.mkDerivation rec {
  pname = "gr-framework";
  version = "0.72.11";

  src = fetchFromGitHub {
    owner = "sciapp";
    repo = "gr";
    rev = "v${version}";
    hash = "sha256-HspDRqO/JKpPeHOfctYAOwwR3y1u+GW3v0OnN7OfLT4=";
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

  meta = with lib; {
    description = "GR framework is a graphics library for visualisation applications";
    homepage = "https://gr-framework.org";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ paveloom ];
  };
}
