{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt5,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "xcursor-viewer";
  version = "0-unstable-2026-01-27";

  src = fetchFromGitHub {
    owner = "drizt";
    repo = "xcursor-viewer";
    rev = "f53e1d261458e84b0f76fb587af560841c413087";
    hash = "sha256-fWkjcXmtU51AQOTK1nLx7Kw9kQtQhUz9EVtAAVX0WEg=";
  };

  nativeBuildInputs = [
    cmake
    qt5.wrapQtAppsHook
  ];

  buildInputs = [ qt5.qtbase ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "A preview application for cursors in xcurosr format built in QT5";
    homepage = "https://github.com/drizt/xcursor-viewer/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ atemu ];
    mainProgram = "xcursor-viewer";
    platforms = lib.platforms.all;
  };
}
