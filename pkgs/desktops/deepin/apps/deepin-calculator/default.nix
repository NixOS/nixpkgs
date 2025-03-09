{
  stdenv,
  lib,
  fetchFromGitHub,
  dtkwidget,
  qt5integration,
  qt5platform-plugins,
  libsForQt5,
  cmake,
  pkg-config,
  gtest,
}:

stdenv.mkDerivation rec {
  pname = "deepin-calculator";
  version = "6.5.2";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-5igRoyXx71LepvWlS+CDRq0q9BFCDitM+83j3Mt6DxU=";
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
    gtest
  ];

  strictDeps = true;

  cmakeFlags = [ "-DVERSION=${version}" ];

  meta = {
    description = "Easy to use calculator for ordinary users";
    mainProgram = "deepin-calculator";
    homepage = "https://github.com/linuxdeepin/deepin-calculator";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.deepin.members;
  };
}
