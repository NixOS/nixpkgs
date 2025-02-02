{
  stdenv,
  lib,
  fetchFromGitHub,
  dtkwidget,
  qt5integration,
  qt5platform-plugins,
  pkg-config,
  libsForQt5,
}:

stdenv.mkDerivation rec {
  pname = "deepin-shortcut-viewer";
  version = "5.0.9";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-A4LFi0KcqChjgYrO90paMBAivv02TsRjYQ26I0k71x0=";
  };

  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.qttools
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtbase
    dtkwidget
    qt5integration
    qt5platform-plugins
  ];

  qmakeFlags = [
    "VERSION=${version}"
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "Deepin Shortcut Viewer";
    mainProgram = "deepin-shortcut-viewer";
    homepage = "https://github.com/linuxdeepin/deepin-shortcut-viewer";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
