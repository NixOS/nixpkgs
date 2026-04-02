{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libxdmcp,
  libexif,
  libfm-qt,
  libpthread-stubs,
  lxqt-build-tools,
  menu-cache,
  qtbase,
  qtimageformats,
  qtsvg,
  qttools,
  qtwayland,
  wrapQtAppsHook,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "lximage-qt";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lximage-qt";
    rev = version;
    hash = "sha256-RJKXcaZJe5gyDubdglOmzmJ9XCH0gAW4fc7OR3anCoU=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt-build-tools
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    libxdmcp
    libexif
    libfm-qt
    libpthread-stubs
    menu-cache
    qtbase
    qtimageformats # add-on module to support more image file formats
    qtsvg
    qtwayland
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/lxqt/lximage-qt";
    description = "Image viewer and screenshot tool for lxqt";
    mainProgram = "lximage-qt";
    license = lib.licenses.gpl2Plus;
    platforms = with lib.platforms; unix;
    teams = [ lib.teams.lxqt ];
  };
}
