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
  version = "0-unstable-2026-01-23";

  src = fetchFromGitHub {
    owner = "drizt";
    repo = "xcursor-viewer";
    rev = "c7aad6c662eab1a0907489d44afbc84ea3aa8de6";
    hash = "sha256-iHnWRcM6UYuhNykH4uiXFmVKnFUiyrLNKtjaAh6ilnw=";
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
