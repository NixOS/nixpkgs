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
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "ySC5bCOnen2bjhmLY4GnwiFaUrvGx93LJrLQo0pBUc4=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    perl # needed by LXQtTranslateDesktop.cmake
    autoPatchelfHook # fix libuploader.so and libextedit.so not found
  ];

  buildInputs = [
    qtbase
    qttools
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
