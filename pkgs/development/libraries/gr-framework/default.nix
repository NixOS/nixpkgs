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
  version = "0.73.3";

  src = fetchFromGitHub {
    owner = "sciapp";
    repo = "gr";
    rev = "v${version}";
    hash = "sha256-Lx6vVyp4mimz7Z6Kc8nTKuZYZEoKIWpoWtbsP05t1D4=";
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
