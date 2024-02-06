{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, qtbase
, qttools
, qtx11extras
, qtsvg
, kwindowsystem
, libqtxdg
, perl
, xorg
, autoPatchelfHook
, gitUpdater
}:

mkDerivation rec {
  pname = "screengrab";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-mmN3BQum7X0GWTUYauEN2mAo3GWdmtkIl2i84g5cp78=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    perl # needed by LXQtTranslateDesktop.cmake
    qttools
    autoPatchelfHook # fix libuploader.so and libextedit.so not found
  ];

  buildInputs = [
    qtbase
    qtx11extras
    qtsvg
    kwindowsystem
    libqtxdg
    xorg.libpthreadstubs
    xorg.libXdmcp
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/screengrab";
    description = "Crossplatform tool for fast making screenshots";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.lxqt.members;
  };
}
