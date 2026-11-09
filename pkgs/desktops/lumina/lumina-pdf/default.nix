{
  lib,
  mkDerivation,
  fetchFromGitHub,
  qmake,
  qtbase,
  qttools,
  poppler,
}:

mkDerivation rec {
  pname = "lumina-pdf";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "lumina-desktop";
    repo = "lumina-pdf";
    rev = "v${version}";
    hash = "sha256-JqNh5xbLDtAFOqtiF6uHQakI7FKZJLmXS+dCrSyRiiE=";
  };

  sourceRoot = "${src.name}/src-qt5";

  nativeBuildInputs = [
    qmake
    qttools
  ];

  buildInputs = [
    qtbase
    poppler
  ];

  postPatch = ''
    sed -i '1i\#include <memory>\' Renderer-poppler.cpp
  '';

  qmakeFlags = [
    "CONFIG+=WITH_I18N"
    "LRELEASE=${lib.getDev qttools}/bin/lrelease"
  ];

  enableParallelBuilding = false;

  meta = {
    description = "PDF viewer for the Lumina Desktop";
    mainProgram = "lumina-pdf";
    homepage = "https://github.com/lumina-desktop/lumina-pdf";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    teams = [ lib.teams.lumina ];
  };
}
