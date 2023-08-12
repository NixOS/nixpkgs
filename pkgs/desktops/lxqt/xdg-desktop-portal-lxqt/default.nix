{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, kwindowsystem
, libfm-qt
, lxqt-qtplugin
, qtx11extras
, gitUpdater
, extraQtStyles ? []
}:

mkDerivation rec {
  pname = "xdg-desktop-portal-lxqt";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "gH4L6cjx3DjGWcgoqUSnsx4Bn+T9t03AXPB5ZNDa0Nw=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    kwindowsystem
    libfm-qt
    lxqt-qtplugin
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
