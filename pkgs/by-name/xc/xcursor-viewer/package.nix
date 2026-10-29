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
  version = "0-unstable-2026-09-20";

  src = fetchFromGitHub {
    owner = "drizt";
    repo = "xcursor-viewer";
    rev = "6e6c80ddd44498b052976871201ec75e09cc4e64";
    hash = "sha256-vjKQRdZ6viqH9jP0roOSBtnDx59ZHQSoERipTNkbAKI=";
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
