{
  stdenv,
  lib,
  fetchFromGitHub,
  libsForQt5,
  pkg-config,
  libchardet,
  lcms2,
  openjpeg,
}:

stdenv.mkDerivation rec {
  pname = "deepin-pdfium";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-ymJSTAccwRumXrh4VjwarKYgaqadMBrtXM1rjWNfe8o=";
  };

  nativeBuildInputs = [
    libsForQt5.qmake
    pkg-config
  ];

  dontWrapQtApps = true;

  buildInputs = [
    libchardet
    lcms2
    openjpeg
  ];

  meta = {
    description = "development library for pdf on deepin";
    homepage = "https://github.com/linuxdeepin/deepin-pdfium";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.deepin.members;
  };
}
