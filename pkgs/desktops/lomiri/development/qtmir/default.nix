{
  stdenv,
  lib,
  fetchFromGitLab,
  testers,
  cmake,
  cmake-extras,
  pkg-config,
  wrapQtAppsHook,
  gsettings-qt,
  gtest,
  libgbm,
  libqtdbustest,
  libqtdbusmock,
  libuuid,
  lomiri-api,
  lomiri-app-launch,
  lomiri-url-dispatcher,
  lttng-ust,
  mir,
  process-cpp,
  qtbase,
  qtdeclarative,
  qtsensors,
  valgrind,
  protobuf,
  glm,
  boost,
  properties-cpp,
  glib,
  validatePkgConfig,
  wayland,
  xwayland,
}:

stdenv.mkDerivation (finalAttrs: {
  # Not regular qtmir, experimental support for Mir 2.x
  # Currently following https://gitlab.com/ubports/development/core/qtmir/-/tree/personal/sunweaver/debian-upstream
  pname = "qtmir-debian-upstream";
  version = "0.8.0-unstable-2025-05-20";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/qtmir";
    rev = "b35762f5198873560138a810b387ae9401615c02";
    hash = "sha256-v5mdu3XLK4F5O56GDItyeCFsFMey4JaNWwXRlgjKFMA=";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [
	  ./1001-qtmir-mirserver-update-for-Mir-2.22.patch
	  ./1002-qtmir-Update-SurfaceObserverImpl.patch
  ];

  postPatch = ''
    # 10s timeout for Mir startup is too tight for VM tests on weaker hardwre (aarch64)
    substituteInPlace src/platforms/mirserver/qmirserver_p.cpp \
      --replace-fail 'const int timeout = RUNNING_ON_VALGRIND ? 100 : 10' 'const int timeout = RUNNING_ON_VALGRIND ? 900 : 90' \
      --replace-fail 'const int timeout = 10' 'const int timeout = 90'

    # FTBFS on Mir 2.22, patches currently don't cover the demos dir, not super important
    substituteInPlace CMakeLists.txt \
      --replace-fail "\''${CMAKE_INSTALL_FULL_LIBDIR}/qt5/qml" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}" \
      --replace-fail "\''${CMAKE_INSTALL_FULL_LIBDIR}/qt5/plugins/platforms" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtPluginPrefix}/platforms" \
      #--replace-fail 'add_subdirectory(demos)' '# Skipping demos dir' \

    substituteInPlace data/xwayland.qtmir.desktop \
      --replace-fail '/usr/bin/Xwayland' 'Xwayland'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    glib # glib-compile-schemas
    lttng-ust
    pkg-config
    validatePkgConfig
    wrapQtAppsHook
  ];

  buildInputs = [
    cmake-extras
    boost
    gsettings-qt
    libgbm # Mir
    libuuid
    lomiri-api
    lomiri-app-launch
    lomiri-url-dispatcher
    lttng-ust
    mir
    process-cpp
    protobuf
    qtbase
    qtdeclarative
    qtsensors
    valgrind

    glm # included by mir header
    wayland # mirwayland asks for this
    properties-cpp # included by l-a-l header
  ];

  propagatedBuildInputs = [
    # Needs Xwayland on PATH for desktop file, else launching X11 applications crashes qtmir
    xwayland
  ];

  checkInputs = [
    gtest
    libqtdbustest
    libqtdbusmock
  ];

  cmakeFlags = [
    # https://github.com/canonical/mir/commit/e2e89b268ed285e3f2146207e6be9c33ef6f982c
    (lib.cmakeBool "Werror" false)
    (lib.cmakeBool "NO_TESTS" (!finalAttrs.finalPackage.doCheck))
    (lib.cmakeBool "WITH_MIR2" true)
  ];

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  # Tests currently unavailable when building with Mir2
  doCheck = false;

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "QPA plugin to make Qt a Mir server";
    homepage = "https://gitlab.com/ubports/development/core/qtmir";
    license = licenses.lgpl3Only;
    teams = [ teams.lomiri ];
    platforms = platforms.linux;
    pkgConfigModules = [ "qtmirserver" ];
  };
})
