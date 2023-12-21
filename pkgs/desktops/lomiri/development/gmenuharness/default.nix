{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, gitUpdater
, testers
, cmake
, cmake-extras
, dbus
, dbus-test-runner
, glib
, gtest
, libqtdbustest
, lomiri-api
, pkg-config
, qtbase
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gmenuharness";
  version = "0.1.4";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/gmenuharness";
    rev = finalAttrs.version;
    hash = "sha256-MswB8cQvz3JvcJL2zj7szUOBzKRjxzJO7/x+87m7E7c=";
  };

  patches = [
    # Remove when version > 0.1.4
    (fetchpatch {
      name = "0001-gmenuharness-Rename-type-attribute-from-x-canonical-type-to-x-lomiri-type.patch";
      url = "https://gitlab.com/ubports/development/core/gmenuharness/-/commit/70e9ed85792a6ac1950faaf26391ce91e69486ab.patch";
      hash = "sha256-jeue0qrl2JZCt/Yfj4jT210wsF/E+MlbtNT/yFTcw5I=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    cmake-extras
    glib
    lomiri-api
    qtbase
  ];

  nativeCheckInputs = [
    dbus
    dbus-test-runner
  ];

  checkInputs = [
    gtest
    libqtdbustest
  ];

  cmakeFlags = [
    "-Denable_tests=${lib.boolToString finalAttrs.doCheck}"
  ];

  dontWrapQtApps = true;

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  enableParallelChecking = false;

  checkPhase = ''
    runHook preCheck

    dbus-test-runner -t make -p test -p "''${enableParallelChecking:+-j $NIX_BUILD_CORES}"

    runHook postCheck
  '';

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    description = "Library to test GMenuModel structures";
    homepage = "https://gitlab.com/ubports/development/core/gmenuharness";
    license = licenses.gpl3Only;
    maintainers = teams.lomiri.members;
    platforms = platforms.unix;
    pkgConfigModules = [
      "libgmenuharness"
    ];
  };
})
