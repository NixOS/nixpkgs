{
  stdenv,
  lib,
  fetchFromGitHub,
  dtkwidget,
  deepin-gettext-tools,
  qt5integration,
  qmake,
  qtbase,
  qttools,
  qtx11extras,
  pkg-config,
  wrapQtAppsHook,
  udisks2-qt5,
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
    qmake
    qttools
    pkg-config
    wrapQtAppsHook
    deepin-gettext-tools
  ];

  buildInputs = [
    dtkwidget
    udisks2-qt5
    qtx11extras
  ];

  cmakeFlags = [ "-DVERSION=${version}" ];

  # qt5integration must be placed before qtsvg in QT_PLUGIN_PATH
  qtWrapperArgs = [ "--prefix QT_PLUGIN_PATH : ${qt5integration}/${qtbase.qtPluginPrefix}" ];

  meta = with lib; {
    description = "Simple graphical interface for creating file system in a block device";
    mainProgram = "dde-device-formatter";
    homepage = "https://github.com/linuxdeepin/dde-device-formatter";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
