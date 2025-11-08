{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qtbase,
  qtsvg,
  lxqt-build-tools,
  wrapQtAppsHook,
  gitUpdater,
  version ? "4.3.0",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libqtxdg";
  inherit version;

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "libqtxdg";
    tag = finalAttrs.version;
    hash =
      {
        "3.12.0" = "sha256-y+3noaHubZnwUUs8vbMVvZPk+6Fhv37QXUb//reedCU=";
        "4.3.0" = "sha256-aec+NjKkaH8dI0cFVxGehdRGO2aH6BD+aix+IvD+2LI=";
      }
      ."${finalAttrs.version}";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtsvg
  ];

  preConfigure = ''
    cmakeFlagsArray+=(
      "-DQTXDGX_ICONENGINEPLUGIN_INSTALL_PATH=$out/$qtPluginPrefix/iconengines"
      "-DCMAKE_INSTALL_INCLUDEDIR=include"
      "-DCMAKE_INSTALL_LIBDIR=lib"
    )
  '';

  postPatch = lib.optionals (version == "3.12.0") ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.1.0 FATAL_ERROR)" "cmake_minimum_required(VERSION 3.10)"
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/lxqt/libqtxdg";
    description = "Qt implementation of freedesktop.org xdg specs";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.lxqt ];
  };
})
