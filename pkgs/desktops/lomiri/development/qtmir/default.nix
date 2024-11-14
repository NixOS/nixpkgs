{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  testers,
  cmake,
  cmake-extras,
  pkg-config,
  wrapQtAppsHook,
  gsettings-qt,
  gtest,
  libqtdbustest,
  libqtdbusmock,
  libuuid,
  lomiri-api,
  lomiri-app-launch,
  lomiri-url-dispatcher,
  lttng-ust,
  mir_2_15,
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
  version = "0.8.0-unstable-2024-03-06";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/qtmir";
    rev = "de639c3a482ac6c59b9be02abb839a8c96158041";
    hash = "sha256-AKSzkGl6bAoR4I2lolNRUp67VS/PiZnrPpCYtTlKWKc=";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    # Mir 2.15 compatibility patch
    # Remove when https://gitlab.com/ubports/development/core/qtmir/-/merge_requests/70 merged into branch
    (fetchpatch {
      name = "0001-qtmir-Update-for-Mir-2.15-removals.patch";
      url = "https://gitlab.com/ubports/development/core/qtmir/-/commit/ead5cacd4d69094ab956627f4dd94ecaff1fd69e.patch";
      hash = "sha256-hUUUnYwhNH3gm76J21M8gA5okaRd/Go03ZFJ4qn0JUo=";
    })

    # Remove when https://gitlab.com/ubports/development/core/qtmir/-/merge_requests/72 merged in branch
    (fetchpatch {
      name = "0002-qtmir-Add-more-better-GNUInstallDirs-variables-usage.patch";
      url = "https://gitlab.com/ubports/development/core/qtmir/-/commit/87e2cd31052ce15e9625c1327807a320ee5d12af.patch";
      hash = "sha256-MTE9tHw+xJhraEO1up7dLg0UIcmfHXgWOeuyYrVu2wc=";
    })

    # Remove when https://gitlab.com/ubports/development/core/qtmir/-/merge_requests/73 merged in branch
    (fetchpatch {
      name = "0003-qtmir-CMakeLists-Only-require-test-dependencies-when-building-tests.patch";
      url = "https://gitlab.com/ubports/development/core/qtmir/-/commit/b7144e67bcbb4cfbd2283d5d05146fb22b7d8cd4.patch";
      hash = "sha256-Afbj40MopztchDnk6fphTYk86YrQkiK8L1e/oXiL1Mw=";
    })

    # Remove when https://gitlab.com/ubports/development/core/qtmir/-/merge_requests/74 merged in branch
    (fetchpatch {
      name = "0004-qtmir-CMakeLists-Drop-call-of-Qt-internal-macro.patch";
      url = "https://gitlab.com/ubports/development/core/qtmir/-/commit/8f9c599a4dbc4cf35e289157fd0c82df55b9f8d9.patch";
      hash = "sha256-SMAErXnlMtVleWRPgO4xuUI7gAAy6W18LxtgXgetRA4=";
    })
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "\''${CMAKE_INSTALL_FULL_LIBDIR}/qt5/qml" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}" \
      --replace-fail "\''${CMAKE_INSTALL_FULL_LIBDIR}/qt5/plugins/platforms" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtPluginPrefix}/platforms" \

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
    libuuid
    lomiri-api
    lomiri-app-launch
    lomiri-url-dispatcher
    lttng-ust
    mir_2_15
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
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
    pkgConfigModules = [ "qtmirserver" ];
  };
})
