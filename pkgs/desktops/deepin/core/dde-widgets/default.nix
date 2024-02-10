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
  version = "6.0.14";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-bmhT7UhMXtC5wlRtwlVnGjoq8rUQcDSk4rGQ0Xrz9ZI=";
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
    homepage = "https://github.com/linuxdeepin/dde-widgets";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
