{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libXdmcp,
  libexif,
  libfm-qt,
  libpthreadstubs,
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
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lximage-qt";
    rev = version;
    hash = "sha256-4j/5z+kePFXubYXAbIaWYVU+plJv1xEpHHI1IXqbQog=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt-build-tools
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    libXdmcp
    libexif
    libfm-qt
    libpthreadstubs
    menu-cache
    qtbase
    qtimageformats # add-on module to support more image file formats
    qtsvg
    qtwayland
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lximage-qt";
    description = "Image viewer and screenshot tool for lxqt";
    mainProgram = "lximage-qt";
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    teams = [ teams.lxqt ];
  };
}
