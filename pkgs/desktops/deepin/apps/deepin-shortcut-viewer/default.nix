{
  stdenv,
  lib,
  fetchFromGitHub,
  dtkwidget,
  qt5integration,
  qt5platform-plugins,
  qmake,
  qtbase,
  qttools,
  pkg-config,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "deepin-shortcut-viewer";
  version = "5.0.7";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-r/ZhA9yiPnJNTrBkVOvaTqfRvGO/NTod5tiQCquG5Gw=";
  };

  nativeBuildInputs = [
    qmake
    qttools
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
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
