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
  version = "0-unstable-2026-07-26";

  src = fetchFromGitHub {
    owner = "drizt";
    repo = "xcursor-viewer";
    rev = "7ce7c1bbcfbc5543f4965e59e6ce496098319aeb";
    hash = "sha256-e0FOkbPqkgZMxNHAosiORQv90sktQWIhMl96gZZrLoA=";
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
