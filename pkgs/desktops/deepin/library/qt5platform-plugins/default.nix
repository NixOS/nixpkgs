{ stdenv
, lib
, fetchFromGitHub
, cmake
, extra-cmake-modules
, pkg-config
, dtkcommon
, qtbase
, qtx11extras
, mtdev
, cairo
, xorg
, wayland
, dwayland
, qtwayland
}:

stdenv.mkDerivation rec {
  pname = "qt5platform-plugins";
  version = "5.6.29";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-KoX3TkEzGNwqG8XL6op0mpTVvdSQTzqd5OpAuCU2Ok4";
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
    qtbase
    qtx11extras
    xorg.libSM
    wayland
    dwayland
    qtwayland
  ];

  cmakeFlags = [
    "-DINSTALL_PATH=${placeholder "out"}/${qtbase.qtPluginPrefix}/platforms"
    "-DQT_XCB_PRIVATE_HEADERS=${qtbase.src}/src/plugins/platforms/xcb"
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
