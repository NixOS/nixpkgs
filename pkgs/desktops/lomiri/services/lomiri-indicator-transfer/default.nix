{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  testers,
  cmake,
  cmake-extras,
  dbus,
  dbus-test-runner,
  gettext,
  glib,
  gtest,
  json-glib,
  lomiri-app-launch,
  pkg-config,
  properties-cpp,
  systemdLibs,
  ubports-click,
  valgrind,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-indicator-transfer-unwrapped";
  version = "1.2.0";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-indicator-transfer";
    tag = finalAttrs.version;
    hash = "sha256-tho1W3SU92p2o8ZqI55FgWFW7VgwbRMaRrqUlBeO5P4=";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    # Only pass suffix, wrapping will set the prefix under which plugins are collected
    ./2001-Handle-plugin-location-via-wrapper.patch
  ];

  postPatch = ''
    substituteInPlace data/CMakeLists.txt \
      --replace-fail 'pkg_get_variable(SYSTEMD_USER_DIR systemd systemduserunitdir)' 'pkg_get_variable(SYSTEMD_USER_DIR systemd systemduserunitdir DEFINE_VARIABLES prefix=''${CMAKE_INSTALL_PREFIX})' \
      --replace-fail '/etc' "\''${CMAKE_INSTALL_SYSCONFDIR}"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
  ];

  buildInputs = [
    glib
    json-glib
    lomiri-app-launch
    properties-cpp
    systemdLibs
    ubports-click
  ];

  nativeCheckInputs = [
    dbus
    valgrind
  ];

  checkInputs = [
    cmake-extras
    dbus-test-runner
    gtest
  ];

  cmakeFlags = [
    (lib.cmakeBool "enable_tests" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "enable_lcov" false)
    (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" (
      let
        disabledTests =
          [
            # Errors on untouched code in tests, maybe hasn't been run in awhile by upstream
            "cppcheck"
          ]
          ++ lib.optionals stdenv.hostPlatform.isAarch64 [
            # https://gitlab.com/ubports/development/core/lomiri-indicator-transfer/-/issues/3
            "test-multisource"
          ];
      in
      lib.optionalString (lib.lists.length disabledTests > 0) (
        lib.concatStringsSep ";" [
          "-E"
          (lib.strings.escapeShellArg "^(${lib.concatStringsSep "|" disabledTests})")
        ]
      )
    ))
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      # version is major.0.0
      versionCheck = false;
    };
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Indicator which shows file/data transfers in the indicator bar";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-indicator-transfer";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-indicator-transfer/-/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl3Only;
    maintainers = lib.teams.lomiri.members;
    pkgConfigModules = [
      "lomiri-indicator-transfer"
    ];
    platforms = lib.platforms.linux;
  };
})
