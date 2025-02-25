{
  stdenv,
  lib,
  fetchFromGitHub,
  freetype,
  icu,
  libsForQt5,
  pkg-config,
  libchardet,
  libjpeg,
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
    freetype
    icu
    libchardet
    libjpeg
    lcms2
    openjpeg
  ];

  meta = with lib; {
    description = "Development library for PDF on deepin";
    homepage = "https://github.com/linuxdeepin/deepin-pdfium";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
