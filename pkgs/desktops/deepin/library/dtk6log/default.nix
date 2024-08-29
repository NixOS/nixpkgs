{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6Packages,
  spdlog,
  systemd,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dtk6log";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "dtk6log";
    rev = finalAttrs.version;
    hash = "sha256-R+jxlS8/FXUxnnzIDIePU2NwwNQU624n++E3q3oElco=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6Packages.wrapQtAppsHook
  ];

  dontWrapQtApps = true;

  buildInputs = [
    qt6Packages.qtbase
    spdlog
  ] ++ lib.optional withSystemd systemd;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_WITH_QT6" true)
    (lib.cmakeBool "BUILD_WITH_SYSTEMD" withSystemd)
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
  ];

  meta = {
    description = "Simple, convinient and thread safe logger for Qt-based C++ apps";
    homepage = "https://github.com/linuxdeepin/dtk6log";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.deepin.members;
  };
})
