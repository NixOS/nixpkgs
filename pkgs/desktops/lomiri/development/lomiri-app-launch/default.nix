{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, gitUpdater
, testers
, cmake
, cmake-extras
, curl
, dbus
, dbus-test-runner
, dpkg
, gobject-introspection
, gtest
, json-glib
, libxkbcommon
, lomiri-api
, lttng-ust
, pkg-config
, properties-cpp
, python3
, systemd
, ubports-click
, validatePkgConfig
, zeitgeist
, withDocumentation ? true
, doxygen
, python3Packages
, sphinx
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-app-launch";
  version = "0.1.9";

  outputs = [
    "out"
    "dev"
  ] ++ lib.optionals withDocumentation [
    "doc"
  ];

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-app-launch";
    rev = finalAttrs.version;
    hash = "sha256-vuu6tZ5eDJN2rraOpmrDddSl1cIFFBSrILKMJqcUDVc=";
  };

  patches = [
    # Remove when version > 0.1.9
    (fetchpatch {
      name = "0001-lomiri-app-launch-Fix-typelib-gir-dependency.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-app-launch/-/commit/8466e77914e73801499df224fcd4a53c4a0eab25.patch";
      hash = "sha256-11pEhFi39Cvqb9Hg47kT8+5hq+bz6WmySqaIdwt1MVk=";
    })

    # Use /run/current-system/sw/bin fallback for desktop file Exec= lookups, propagate to launched applications
    ./2001-Inject-current-system-PATH.patch
  ];

  postPatch = ''
    patchShebangs tests/{desktop-hook-test.sh.in,repeat-until-pass.sh}

    # used pkg_get_variable, cannot replace prefix
    substituteInPlace data/CMakeLists.txt \
      --replace-fail 'pkg_get_variable(SYSTEMD_USER_UNIT_DIR systemd systemduserunitdir)' 'pkg_get_variable(SYSTEMD_USER_UNIT_DIR systemd systemduserunitdir DEFINE_VARIABLES prefix=''${CMAKE_INSTALL_PREFIX})'

    substituteInPlace tests/jobs-systemd.cpp \
      --replace-fail '^(/usr)?' '^(/nix/store/\\w+-bash-.+)?'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    dpkg # for setting LOMIRI_APP_LAUNCH_ARCH
    gobject-introspection
    pkg-config
    validatePkgConfig
  ] ++ lib.optionals withDocumentation [
    doxygen
    python3Packages.breathe
    sphinx
  ];

  buildInputs = [
    cmake-extras
    curl
    dbus
    json-glib
    libxkbcommon
    lomiri-api
    lttng-ust
    properties-cpp
    systemd
    ubports-click
    zeitgeist
  ];

  nativeCheckInputs = [
    dbus
    (python3.withPackages (ps: with ps; [
      python-dbusmock
    ]))
  ];

  checkInputs = [
    dbus-test-runner
    gtest
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_MIRCLIENT" false)
    (lib.cmakeBool "ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" (lib.concatStringsSep ";" [
      # Exclude tests
      "-E" (lib.strings.escapeShellArg "(${lib.concatStringsSep "|" [
        # Flaky, randomly hangs
        # https://gitlab.com/ubports/development/core/lomiri-app-launch/-/issues/19
        "^helper-handshake-test"
      ]})")
    ]))
  ];

  postBuild = lib.optionalString withDocumentation ''
    make -C ../docs html
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  postInstall = lib.optionalString withDocumentation ''
    mkdir -p $doc/share/doc/lomiri-app-launch
    mv ../docs/_build/html $doc/share/doc/lomiri-app-launch/
  '';

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = {
    description = "System and associated utilities to launch applications in a standard and confined way";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-app-launch";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-app-launch/-/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl3Only;
    maintainers = lib.teams.lomiri.members;
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "lomiri-app-launch-0"
    ];
  };
})
