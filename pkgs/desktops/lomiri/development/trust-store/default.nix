{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  makeFontsConf,
  testers,
  boost,
  cmake,
  cmake-extras,
  ctestCheckHook,
  dbus,
  dbus-cpp,
  doxygen,
  gettext,
  glog,
  graphviz,
  gtest,
  libapparmor,
  newt,
  pkg-config,
  process-cpp,
  properties-cpp,
  qtbase,
  qtdeclarative,
  validatePkgConfig,
  wayland,
  writableTmpDirAsHomeHook,
  withDocumentation ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "trust-store";
  version = "2.0.3";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/trust-store";
    rev = finalAttrs.version;
    hash = "sha256-L9UnqnpDqVOqzkRejzlw4BGSTaS+mT/h8CCV8vo0T4c=";
  };

  outputs = [
    "out"
    "dev"
    "bin"
  ]
  ++ lib.optionals withDocumentation [
    "doc"
  ];

  postPatch =
    # pkg-config patching hook expects prefix variable
    ''
      substituteInPlace data/trust-store.pc.in \
        --replace-fail 'libdir=''${exec_prefix}' 'libdir=''${prefix}' \
        --replace-fail 'includedir=''${exec_prefix}' 'includedir=''${prefix}'
    ''
    + ''
      substituteInPlace src/core/trust/terminal_agent.h \
        --replace-fail '/bin/whiptail' '${lib.getExe' newt "whiptail"}'
    ''
    # We don't want to install the test binaries. Patching this out completely would require touching multiple lines.
    # TODO Add a CMake option() for controlling this, submit upstream
    + ''
      substituteInPlace tests/CMakeLists.txt \
        --replace-fail \
          "\''${CMAKE_INSTALL_LIBDIR}/trust-store-tests" \
          "$(mktemp -d)"
    ''
    + lib.optionalString (!finalAttrs.finalPackage.doCheck) ''
      substituteInPlace CMakeLists.txt \
        --replace-fail 'add_subdirectory(tests)' ""

      sed -i -e '/xdg_test/d' 3rd_party/xdg/CMakeLists.txt
    '';

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
    validatePkgConfig
  ]
  ++ lib.optionals withDocumentation [
    doxygen
    graphviz
    writableTmpDirAsHomeHook # silencing fontconfig warnings
  ];

  buildInputs = [
    boost
    cmake-extras
    dbus-cpp
    glog
    libapparmor
    newt
    process-cpp
    properties-cpp
    qtbase
    qtdeclarative
    wayland
  ];

  nativeCheckInputs = [
    ctestCheckHook
    dbus
    writableTmpDirAsHomeHook
  ];

  checkInputs = [
    gtest
  ];

  # Library
  dontWrapQtApps = true;

  cmakeFlags = [
    # error: moving a temporary object prevents copy elision
    (lib.strings.cmakeBool "ENABLE_WERROR" true)
    (lib.strings.cmakeBool "TRUST_STORE_ENABLE_DOC_GENERATION" withDocumentation)
    # Requires mirclient API, unavailable in Mir 2.x
    # https://gitlab.com/ubports/development/core/trust-store/-/issues/2
    (lib.strings.cmakeBool "TRUST_STORE_MIR_AGENT_ENABLED" false)
    (lib.strings.cmakeBool "TRUST_STORE_WAYLAND_AGENT_ENABLED" true)
    (lib.strings.cmakeFeature "CMAKE_BUILD_TYPE" "Debug")
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  disabledTests = [
    # Getting an std::system_error with "Invalid argument", I *think* from aa_get_task_con_app_id_resolver.
    # We don't really use AppArmor, and especially not in the test sandbox.
    "remote_agent_test"
  ];

  preCheck = ''
    export XDG_DATA_HOME=$HOME
  '';

  # Starts & talks to DBus
  enableParallelChecking = false;

  env = lib.optionalAttrs withDocumentation {
    # silence fontconfig warnings
    FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ ]; };
  };

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      versionCheck = true;
    };
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Common implementation of a trust store to be used by trusted helpers";
    homepage = "https://gitlab.com/ubports/development/core/trust-store";
    license = lib.licenses.lgpl3Only;
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "trust-store"
    ];
  };
})
