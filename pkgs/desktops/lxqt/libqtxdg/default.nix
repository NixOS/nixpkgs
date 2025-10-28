{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  qtbase,
  qtsvg,
  lxqt-build-tools,
  wrapQtAppsHook,
  gitUpdater,
  version ? "4.2.0",
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
        "4.2.0" = "sha256-TSyVYlWsmB/6gxJo+CjROBQaWsmYZAwkM8BwiWP+XBI=";
      }
      ."${finalAttrs.version}";
  };

  patches = lib.optionals (finalAttrs.version == "4.2.0") [
    # fix build against Qt >= 6.10 (https://github.com/lxqt/libqtxdg/pull/313)
    # TODO: drop when upgrading beyond version 4.2.0
    (fetchpatch {
      name = "cmake-fix-build-with-Qt-6.10.patch";
      url = "https://github.com/lxqt/libqtxdg/commit/b01a024921acdfd5b0e97d5fda2933c726826e99.patch";
      hash = "sha256-njpn6pU9BHlfYfkw/jEwh8w3Wo1F8MlRU8iQB+Tz2zU=";
    })
  ];

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
