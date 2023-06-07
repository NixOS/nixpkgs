{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, qtbase
, qttools
, qtx11extras
, qtsvg
, qtimageformats
, xorg
, lxqt-build-tools
, libfm-qt
, libexif
, menu-cache
, gitUpdater
}:

mkDerivation rec {
  pname = "lximage-qt";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "afCW3VeXAq2HYc4fjSrd+7j6cGoHmGlO8jCiNq6/F3E=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qttools
    qtx11extras
    qtsvg
    qtimageformats # add-on module to support more image file formats
    libfm-qt
    xorg.libpthreadstubs
    xorg.libXdmcp
    libexif
    menu-cache
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lximage-qt";
    description = "The image viewer and screenshot tool for lxqt";
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    maintainers = teams.lxqt.members;
  };
}
