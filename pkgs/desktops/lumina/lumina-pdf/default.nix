{ stdenv, fetchFromGitHub, qmake, qtbase, qttools, poppler }:

stdenv.mkDerivation rec {
  pname = "lumina-pdf";
  version = "2019-04-27";

  src = fetchFromGitHub {
    owner = "lumina-desktop";
    repo = pname;
    rev = "645ed591ef91c3607d3ab87dd86f7acfd08b05c9";
    sha256 = "0gl943jb9c9rcgb5wksx3946hwlifghfd27r97skm9is8ih6k0vn";
  };
  
  sourceRoot = "source/src-qt5";

  nativeBuildInputs = [ qmake qttools ];

  buildInputs = [ qtbase poppler ];

  postPatch = ''
    sed -i '1i\#include <memory>\' Renderer-poppler.cpp
  '';

  qmakeFlags = [
    "CONFIG+=WITH_I18N"
    "LRELEASE=${stdenv.lib.getDev qttools}/bin/lrelease"
  ];

  enableParallelBuilding = false;

  meta = with stdenv.lib; {
    description = "PDF viewer for the Lumina Desktop";
    homepage = https://github.com/lumina-desktop/lumina-pdf;
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
