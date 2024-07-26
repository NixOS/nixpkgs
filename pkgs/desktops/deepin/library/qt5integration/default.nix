{ stdenv
, lib
, fetchFromGitHub
, dtkwidget
, cmake
, pkg-config
, libsForQt5
, lxqt
, mtdev
, xorg
, gtest
}:

stdenv.mkDerivation rec {
  pname = "qt5integration";
  version = "5.6.32";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-WRMeH66X21Z6TBKPEabnWqzC95+OR9M5azxvAp6K7T4=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    dtkwidget
    libsForQt5.qtbase
    libsForQt5.qtsvg
    libsForQt5.qtx11extras
    mtdev
    lxqt.libqtxdg_3_12
    xorg.xcbutilrenderutil
    gtest
  ];

  cmakeFlags = [
    "-DPLUGIN_INSTALL_BASE_DIR=${placeholder "out"}/${libsForQt5.qtbase.qtPluginPrefix}"
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Qt platform theme integration plugins for DDE";
    homepage = "https://github.com/linuxdeepin/qt5integration";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
