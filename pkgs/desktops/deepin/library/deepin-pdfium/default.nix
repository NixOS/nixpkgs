{
  stdenv,
  lib,
  fetchFromGitHub,
  qmake,
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
    qmake
    pkg-config
  ];

  dontWrapQtApps = true;

  buildInputs = [
    libchardet
    lcms2
    openjpeg
  ];

  meta = with lib; {
    description = "development library for pdf on deepin";
    homepage = "https://github.com/linuxdeepin/deepin-pdfium";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
