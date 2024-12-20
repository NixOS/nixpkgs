{
  stdenv,
  lib,
  fetchFromGitHub,
  dtkwidget,
  qt5integration,
  qt5platform-plugins,
  libsForQt5,
  dde-qt-dbus-factory,
  cmake,
  pkg-config,
  gtest,
}:

stdenv.mkDerivation rec {
  pname = "deepin-calculator";
  version = "5.8.24";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-Gv4X1vT3w3kd1FN6BBpUeG2VBz/e+OWLBQyBL7r3BrI=";
  };

  nativeBuildInputs = [
    cmake
    libsForQt5.qttools
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    dtkwidget
    qt5integration
    qt5platform-plugins
    libsForQt5.qtbase
    libsForQt5.qtsvg
    dde-qt-dbus-factory
    gtest
  ];

  strictDeps = true;

  cmakeFlags = [ "-DVERSION=${version}" ];

  meta = with lib; {
    description = "Easy to use calculator for ordinary users";
    mainProgram = "deepin-calculator";
    homepage = "https://github.com/linuxdeepin/deepin-calculator";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
