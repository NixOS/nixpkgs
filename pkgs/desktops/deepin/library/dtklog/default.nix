{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libsForQt5,
  spdlog,
  systemd,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dtklog";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "dtklog";
    rev = finalAttrs.version;
    hash = "sha256-8c3KL6pjAFPC4jRpOpPEbEDRBMWnDptwBSbEtcQcf5E=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  dontWrapQtApps = true;

  buildInputs = [
    libsForQt5.qtbase
    spdlog
  ] ++ lib.optional withSystemd systemd;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_WITH_SYSTEMD" withSystemd)
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
  ];

  meta = {
    description = "Deepin tool kit core library";
    homepage = "https://github.com/linuxdeepin/dtkcore";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.deepin.members;
  };
})
