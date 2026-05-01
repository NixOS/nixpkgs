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
  version = "0-unstable-2026-01-05";

  src = fetchFromGitHub {
    owner = "drizt";
    repo = "xcursor-viewer";
    rev = "216ed3b6b4694f75fc424862874dc5e2b66fb685";
    hash = "sha256-faQuxHrUAqqSODDKZrRlMnWRj0NeM8hSHSbec7KSo50=";
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
