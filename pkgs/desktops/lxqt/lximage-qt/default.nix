{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, libXdmcp
, libexif
, libfm-qt
, libpthreadstubs
, lxqt-build-tools
, menu-cache
, qtbase
, qtimageformats
, qtsvg
, qttools
, qtwayland
, wrapQtAppsHook
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "lximage-qt";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-I0DyC8i+OnHxHcpp/xPsKjr3UgvUHlVO8h9Tjhg7Pg8=";
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
    description = "The image viewer and screenshot tool for lxqt";
    mainProgram = "lximage-qt";
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    maintainers = teams.lxqt.members;
  };
}
