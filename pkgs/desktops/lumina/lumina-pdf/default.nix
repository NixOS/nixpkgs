{ lib, mkDerivation, fetchFromGitHub, qmake, qtbase, qttools, poppler }:

mkDerivation rec {
  pname = "lumina-pdf";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "lumina-desktop";
    repo = pname;
    rev = "v${version}";
    sha256 = "08caj4nashp79fbvj94rabn0iaa1hymifqmb782x03nb2vkn38r6";
  };

  sourceRoot = "${src.name}/src-qt5";

  nativeBuildInputs = [ qmake qttools ];

  buildInputs = [ qtbase poppler ];

  postPatch = ''
    sed -i '1i\#include <memory>\' Renderer-poppler.cpp
  '';

  qmakeFlags = [
    "CONFIG+=WITH_I18N"
    "LRELEASE=${lib.getDev qttools}/bin/lrelease"
  ];

  enableParallelBuilding = false;

  meta = with lib; {
    description = "PDF viewer for the Lumina Desktop";
    homepage = "https://github.com/lumina-desktop/lumina-pdf";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = teams.lumina.members;
  };
}
