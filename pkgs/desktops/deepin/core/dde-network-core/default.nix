{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  dtkwidget,
  dde-control-center,
  dde-session-shell,
  libsForQt5,
  glib,
  gtest,
}:

stdenv.mkDerivation rec {
  pname = "dde-network-core";
  version = "2.0.34";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-bS/PkutP5BQtqZ6MzeImFyGKoztoTswXhXaEftEv0FI=";
  };

  nativeBuildInputs = [
    cmake
    libsForQt5.qttools
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtsvg
    dtkwidget
    dde-control-center
    dde-session-shell
    libsForQt5.networkmanager-qt
    glib
    gtest
  ];

  cmakeFlags = [ "-DVERSION=${version}" ];

  strictDeps = true;

  meta = {
    description = "DDE network library framework";
    homepage = "https://github.com/linuxdeepin/dde-network-core";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.deepin.members;
  };
}
