{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kwindowsystem,
  libexif,
  libfm-qt,
  lxqt-qtplugin,
  menu-cache,
  qtbase,
  wrapQtAppsHook,
  gitUpdater,
  extraQtStyles ? [ ],
}:

stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal-lxqt";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-y3VqDuFagKcG8O5m5qjRGtlUZXfIXV0tclvZLChhWkg=";
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    kwindowsystem
    libexif
    libfm-qt
    lxqt-qtplugin
    menu-cache
    qtbase
  ]
  ++ extraQtStyles;

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/lxqt/xdg-desktop-portal-lxqt";
    description = "Backend implementation for xdg-desktop-portal that is using Qt/KF5/libfm-qt";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ romildo ];
  };
}
