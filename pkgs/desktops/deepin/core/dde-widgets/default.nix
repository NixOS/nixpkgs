{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, dde-qt-dbus-factory
, wrapQtAppsHook
, qtbase
, qtx11extras
, dtkwidget
, qt5integration
, gtest
}:

stdenv.mkDerivation rec {
  pname = "dde-widgets";
  version = "6.0.22";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-rE/7AoTID9UWxAS+LVYY5WYDNAo8GnSJmUrJFn3l+1M=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    dde-qt-dbus-factory
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtx11extras
    dtkwidget
    qt5integration
    gtest
  ];

  meta = with lib; {
    description = "Desktop widgets service/implementation for DDE";
    mainProgram = "dde-widgets";
    homepage = "https://github.com/linuxdeepin/dde-widgets";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
