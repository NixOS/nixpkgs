{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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
    repo = "xdg-desktop-portal-lxqt";
    rev = version;
    hash = "sha256-y3VqDuFagKcG8O5m5qjRGtlUZXfIXV0tclvZLChhWkg=";
  };

  patches = [
    # fix build against Qt >= 6.10 (https://github.com/lxqt/xdg-desktop-portal-lxqt/pull/50)
    # TODO: drop when upgrading beyond version 1.2.0
    (fetchpatch {
      name = "cmake-fix-build-with-Qt-6.10.patch";
      url = "https://github.com/lxqt/xdg-desktop-portal-lxqt/commit/15fae3c57a8e8149ef19a8c919f5728016390e3f.patch";
      hash = "sha256-oReYMEr+tBDHtnFDZahBwTtzgtL/BABZO64yob9tem4=";
    })
  ];

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

  meta = with lib; {
    homepage = "https://github.com/lxqt/xdg-desktop-portal-lxqt";
    description = "Backend implementation for xdg-desktop-portal that is using Qt/KF5/libfm-qt";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
