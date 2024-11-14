{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  dde-qt-dbus-factory,
  dtkwidget,
  libsForQt5,
  qt5integration,
  gtest,
}:

stdenv.mkDerivation rec {
  pname = "dde-widgets";
  version = "6.0.23";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-aeWQdWi1mMche7AJhAvchRXu89hiZ+CM/RR9HvvbXTw=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    dde-qt-dbus-factory
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtx11extras
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
