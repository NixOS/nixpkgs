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

stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal-lxqt";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "xdg-desktop-portal-lxqt";
    tag = finalAttrs.version;
    hash = "sha256-DNlvqZzTzZURuHTURBUXaLvMKy2HxVpgI9JwJq6A5Sw=";
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
    maintainers = [ lib.maintainers.romildo ];
  };
})
