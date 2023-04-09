{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, dtkwidget
, qt5integration
, qt5platform-plugins
, dde-qt-dbus-factory
, cmake
, qtbase
, qtsvg
, qttools
, qtx11extras
, pkg-config
, wrapQtAppsHook
, at-spi2-core
, libsecret
, chrpath
, lxqt
, gtest
}:

stdenv.mkDerivation rec {
  pname = "deepin-terminal";
  version = "5.9.40";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-GtrbR59IUYNAOmioW5NYhDsPKBmK4uybyDjHsbelkE4=";
  };

  patches = [
    (fetchpatch {
      name = "chore: use GNUInstallDirs in CmakeLists";
      url = "https://github.com/linuxdeepin/deepin-terminal/commit/b18a2ca8411f09f5573aa2a8403a484b693ec975.patch";
      sha256 = "sha256-Qy8Jg+7BfZr8tQEsCAzhMEwf6rU96gkgup5f9bMMELY=";
    })
  ];

  cmakeFlags = [ "-DVERSION=${version}" ];

  nativeBuildInputs = [
    cmake
    qttools
    pkg-config
    wrapQtAppsHook
    lxqt.lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qtsvg
    dtkwidget
    qt5integration
    qt5platform-plugins
    dde-qt-dbus-factory
    qtx11extras
    at-spi2-core
    libsecret
    chrpath
    gtest
  ];

  strictDeps = true;

  meta = with lib; {
    description = "Terminal emulator with workspace, multiple windows, remote management, quake mode and other features";
    homepage = "https://github.com/linuxdeepin/deepin-terminal";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
