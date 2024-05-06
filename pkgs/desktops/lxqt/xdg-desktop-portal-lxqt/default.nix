{ lib
, stdenv
, fetchFromGitHub
, cmake
, kwindowsystem
, libexif
, libfm-qt
, lxqt-qtplugin
, menu-cache
, qtbase
, wrapQtAppsHook
, gitUpdater
, extraQtStyles ? []
}:

stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal-lxqt";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-JSbFZ7R1Cu5VPPb50fRVSAsaE0LE15BbbHpvJZP6+w0=";
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

  meta = with lib; {
    homepage = "https://github.com/lxqt/xdg-desktop-portal-lxqt";
    description = "Backend implementation for xdg-desktop-portal that is using Qt/KF5/libfm-qt";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
