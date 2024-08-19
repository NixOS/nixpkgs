{ stdenv
, lib
, fetchFromGitHub
, cmake
, extra-cmake-modules
, pkg-config
, dtkcommon
, libsForQt5
, mtdev
, cairo
, xorg
, wayland
, dwayland
}:

stdenv.mkDerivation rec {
  pname = "qt5platform-plugins";
  version = "5.6.32";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-jbt+ym6TQX3tecFCSlz8Z2ZnqOa69zYgaB5ohQM3lQg=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
  ];

  buildInputs = [
    dtkcommon
    mtdev
    cairo
    libsForQt5.qtbase
    libsForQt5.qtx11extras
    xorg.libSM
    wayland
    dwayland
    libsForQt5.qtwayland
  ];

  cmakeFlags = [
    "-DINSTALL_PATH=${placeholder "out"}/${libsForQt5.qtbase.qtPluginPrefix}/platforms"
    "-DQT_XCB_PRIVATE_HEADERS=${libsForQt5.qtbase.src}/src/plugins/platforms/xcb"
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Qt platform plugins for DDE";
    homepage = "https://github.com/linuxdeepin/qt5platform-plugins";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
