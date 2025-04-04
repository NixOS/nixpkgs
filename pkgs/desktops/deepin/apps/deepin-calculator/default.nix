{
  stdenv,
  lib,
  fetchFromGitHub,
  dtk6widget,
  qt6integration,
  qt6platform-plugins,
  qt6Packages,
  cmake,
  pkg-config,
  gtest,
}:

stdenv.mkDerivation rec {
  pname = "deepin-calculator";
  version = "6.5.7";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-p3tEUIM7rxYUVLl7ZaEm20IZWRMNi12AIj9mQe6iB5I=";
  };

  nativeBuildInputs = [
    cmake
    qt6Packages.qttools
    pkg-config
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    dtk6widget
    qt6integration
    qt6platform-plugins
    qt6Packages.qtbase
    qt6Packages.qtsvg
    gtest
  ];

  # qtsvg can't not be found with strictDeps
  strictDeps = false;

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
