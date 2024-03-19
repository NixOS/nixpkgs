{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, kwindowsystem
, libexif
, libfm-qt
, lxqt-qtplugin
, menu-cache
, qtx11extras
, gitUpdater
, extraQtStyles ? []
}:

mkDerivation rec {
  pname = "xdg-desktop-portal-lxqt";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-6yfLjDK8g8cpeeyuFUEjERTLLn6h3meKjD2Eb7Cj9qY=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    kwindowsystem
    libexif
    libfm-qt
    lxqt-qtplugin
    menu-cache
    qtx11extras
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
