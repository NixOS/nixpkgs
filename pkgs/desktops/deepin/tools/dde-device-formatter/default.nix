{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  deepin-gettext-tools,
  libsForQt5,
  dtkwidget,
  udisks2-qt5,
  qt5platform-plugins,
  qt5integration,
}:

stdenv.mkDerivation rec {
  pname = "dde-device-formatter";
  version = "0.0.1.16";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-l2D+j+u5Q6G45KTM7eg1QNEakEPtEJ0tzlDlQO5/08I=";
  };

  postPatch = ''
    substituteInPlace translate_desktop2ts.sh translate_ts2desktop.sh \
      --replace "/usr/bin/deepin-desktop-ts-convert" "deepin-desktop-ts-convert"
    substituteInPlace dde-device-formatter.pro dde-device-formatter.desktop \
      --replace "/usr" "$out"
    patchShebangs *.sh
  '';

  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.qttools
    libsForQt5.wrapQtAppsHook
    pkg-config
    deepin-gettext-tools
  ];

  buildInputs = [
    dtkwidget
    udisks2-qt5
    qt5platform-plugins
    qt5integration
    libsForQt5.qtx11extras
  ];

  cmakeFlags = [ "-DVERSION=${version}" ];

  meta = {
    description = "Simple graphical interface for creating file system in a block device";
    mainProgram = "dde-device-formatter";
    homepage = "https://github.com/linuxdeepin/dde-device-formatter";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.deepin.members;
  };
}
