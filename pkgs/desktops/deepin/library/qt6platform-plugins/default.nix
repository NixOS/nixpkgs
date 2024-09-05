{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  mtdev,
  cairo,
  xorg,
  qt6Packages,
}:

stdenv.mkDerivation rec {
  pname = "qt6platform-plugins";
  version = "6.0.18";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-O2wylkNKqN0JxKffwFNSfv7S1hPIFrVKwSsppSGTp6I=";
  };

  postUnpack = ''
    tar -xf ${qt6Packages.qtbase.src}
    mv qtbase-everywhere-src-${qt6Packages.qtbase.version}/src/plugins/platforms/xcb ${src.name}/xcb/libqt6xcbqpa-dev/${qt6Packages.qtbase.version}
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    mtdev
    cairo
    xorg.libSM
    qt6Packages.qtbase
  ];

  cmakeFlags = [
    "-DDTK_VERSION=${version}"
    "-DINSTALL_PATH=${placeholder "out"}/${qt6Packages.qtbase.qtPluginPrefix}/platforms"
  ];

  dontWrapQtApps = true;

  meta = {
    description = "Qt platform plugins for DDE";
    homepage = "https://github.com/linuxdeepin/qt6platform-plugins";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.deepin.members;
  };
}
