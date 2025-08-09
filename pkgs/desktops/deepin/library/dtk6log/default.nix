{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  qt6Packages,
  spdlog,
  systemd,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dtk6log";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "dtk6log";
    rev = finalAttrs.version;
    hash = "sha256-uPuka+uVCcl2sBMr1SpgqLpcIqZm6BDZyGd7FOraHVM=";
  };

  patches = [
    (fetchpatch {
      name = "resolve-compilation-issues-on-Qt-6_9.patch";
      url = "https://github.com/linuxdeepin/dtklog/commit/ab7ed5aa8433c726470f2aecc1d99f118eae8b63.patch";
      hash = "sha256-QK4MOAzTZjjK5qfmzguXAgHO9guMCRN/5y+llBSY2vk=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6Packages.wrapQtAppsHook
  ];

  dontWrapQtApps = true;

  buildInputs = [
    qt6Packages.qtbase
    spdlog
  ]
  ++ lib.optional withSystemd systemd;

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
    teams = [ lib.teams.deepin ];
  };
})
