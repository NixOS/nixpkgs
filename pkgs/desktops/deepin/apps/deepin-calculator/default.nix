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
  version = "6.5.4";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-yLLdQCnEfcKm0su9gIMRDwOxOjLRjrOqf7AkC7PvAwM=";
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
