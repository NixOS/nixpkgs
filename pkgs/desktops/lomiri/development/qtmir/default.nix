{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  fetchDebianPatch,
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
  lomiri-content-hub,
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

  patches =
    let
      fetchQtmirDebianPatch =
        args:
        fetchDebianPatch (
          {
            pname = "qtmir";
            # personal/sunweaver/debian-upstream has advanced past Debian's packaging, includes some of the patches
            version = "0.8.0~git20250407.ea2f477";
            debianRevision = "7";
          }
          // args
        );
    in
    [
      # Yes, we're reverting the latest commit. Patch is intentionally un-applied in Debian to fix crashes on non-Asahi platforms.
      (fetchpatch {
        name = "qtmir-revert-src-platforms-Select-GLRenderingProvider-based-on-suitability.patch";
        url = "https://gitlab.com/ubports/development/core/qtmir/-/commit/b35762f5198873560138a810b387ae9401615c02.diff";
        revert = true;
        hash = "sha256-GIogKWw2uBeZzqD3RZN+lIDjASg6j95CLT/JZzffQYQ=";
      })
      (fetchQtmirDebianPatch {
        patch = "0022_modules-MirSurface-try-to-let-Mir-forceClose-dead-su.patch";
        hash = "sha256-oIRKa1QnJLSNaY7xpl3dARzSQPE1b8RhqxZxN7uv1eM=";
      })
      (fetchQtmirDebianPatch {
        patch = "0030_mirserver-update-for-Mir-2.22.patch";
        hash = "sha256-BCfeoU3tWEccjo2ZWvLIXek6yCdpeKpTVErfCVW5qDQ=";
      })
      (fetchQtmirDebianPatch {
        patch = "0031_demos-drop-usage-of-deprecated-Descriptors.patch";
        hash = "sha256-RochYJPSngG60vBaFm+mQo3nO55Tv43JCwvHewBUboY=";
      })
      (fetchQtmirDebianPatch {
        patch = "0032_mirsurface-add-mirror_mode_set_to.patch";
        hash = "sha256-b6hZ4mbxr6JgWtfP9qVuqa7A6WctYZOocc/FYCfzkoE=";
      })
    ];

  postPatch = ''
    # 10s timeout for Mir startup is too tight for VM tests on weaker hardwre (aarch64)
    substituteInPlace src/platforms/mirserver/qmirserver_p.cpp \
      --replace-fail 'const int timeout = RUNNING_ON_VALGRIND ? 100 : 10' 'const int timeout = RUNNING_ON_VALGRIND ? 900 : 90' \
      --replace-fail 'const int timeout = 10' 'const int timeout = 90'

    substituteInPlace CMakeLists.txt \
      --replace-fail "\''${CMAKE_INSTALL_FULL_LIBDIR}/qt5/qml" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}" \
      --replace-fail "\''${CMAKE_INSTALL_FULL_LIBDIR}/qt5/plugins/platforms" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtPluginPrefix}/platforms"

    substituteInPlace data/xwayland.qtmir.desktop \
      --replace-fail '/usr/bin/Xwayland' 'Xwayland'

    # Component got assimilated into other parts in latest Mir, no longer standalone package
    substituteInPlace CMakeLists.txt \
      --replace-fail 'pkg_check_modules(MIRRENDERERGLDEV mir-renderer-gl-dev>=0.26 REQUIRED)' 'pkg_check_modules(MIRRENDERERGLDEV mir-renderer-gl-dev>=0.26)'
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
    lomiri-content-hub
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
    (lib.cmakeBool "WITH_CONTENTHUB" true)
    (lib.cmakeBool "WITH_MIR2" true)
  ];

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  # Tests currently unavailable when building with Mir2
  doCheck = false;

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    description = "QPA plugin to make Qt a Mir server";
    homepage = "https://gitlab.com/ubports/development/core/qtmir";
    license = lib.licenses.lgpl3Only;
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [ "qtmirserver" ];
  };
})
