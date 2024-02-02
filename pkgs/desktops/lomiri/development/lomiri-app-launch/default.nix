{ stdenv
, lib
, fetchFromGitLab
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

  postPatch = ''
    patchShebangs tests/{desktop-hook-test.sh.in,repeat-until-pass.sh}

    # used pkg_get_variable, cannot replace prefix
    substituteInPlace data/CMakeLists.txt \
      --replace 'pkg_get_variable(SYSTEMD_USER_UNIT_DIR systemd systemduserunitdir)' 'set(SYSTEMD_USER_UNIT_DIR "''${CMAKE_INSTALL_PREFIX}/lib/systemd/user")'

    substituteInPlace tests/jobs-systemd.cpp \
      --replace '^(/usr)?' '^(/nix/store/\\w+-bash-.+)?'
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

  meta = with lib; {
    description = "System and associated utilities to launch applications in a standard and confined way";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-app-launch";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-app-launch/-/blob/${finalAttrs.version}/ChangeLog";
    license = licenses.gpl3Only;
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
    pkgConfigModules = [
      "lomiri-app-launch-0"
    ];
  };
})
