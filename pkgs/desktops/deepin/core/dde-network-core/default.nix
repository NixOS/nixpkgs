{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  qttools,
  pkg-config,
  wrapQtAppsHook,
  qtbase,
  qtsvg,
  dtkwidget,
  dde-dock,
  dde-control-center,
  dde-session-shell,
  networkmanager-qt,
  glib,
  gtest,
}:

stdenv.mkDerivation rec {
  pname = "dde-network-core";
  version = "2.0.31";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-vTcADZElqNZMzWKDCEFtH3oXNyW8i4wxAwnaBnyz6X8=";
  };

  nativeBuildInputs = [
    cmake
    qttools
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtsvg
    dtkwidget
    dde-dock
    dde-control-center
    dde-session-shell
    networkmanager-qt
    glib
    gtest
  ];

  cmakeFlags = [ "-DVERSION=${version}" ];

  strictDeps = true;

  meta = with lib; {
    description = "DDE network library framework";
    homepage = "https://github.com/linuxdeepin/dde-network-core";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
