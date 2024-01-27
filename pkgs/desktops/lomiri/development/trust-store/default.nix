{ stdenv
, lib
, fetchFromGitLab
, testers
, boost
, cmake
, cmake-extras
, dbus
, dbus-cpp
, doxygen
, gettext
, glog
, graphviz
, gtest
, libapparmor
, newt
, pkg-config
, process-cpp
, properties-cpp
, qtbase
, qtdeclarative
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "trust-store";
  version = "0-unstable-2023-12-27";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/trust-store";
    rev = "c91e5ac54c4032525f930f0651d673ad3a1095a2";
    hash = "sha256-zqs40tKo2AOd9yL2Xfbk52Uh8hy4uT1XDT6YtKufAaY=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
    "bin"
  ];

  postPatch = ''
    # pkg-config patching hook expects prefix variable
    substituteInPlace data/trust-store.pc.in \
      --replace 'includedir=''${exec_prefix}' 'includedir=''${prefix}'

    substituteInPlace src/core/trust/terminal_agent.h \
      --replace '/bin/whiptail' '${lib.getExe' newt "whiptail"}'
  '' + lib.optionalString (!finalAttrs.doCheck) ''
    sed -i CMakeLists.txt -e '/add_subdirectory(tests)/d'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    gettext
    graphviz
    pkg-config
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
  ];

  nativeCheckInputs = [
    dbus
  ];

  checkInputs = [
    gtest
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    # Requires mirclient API, unavailable in Mir 2.x
    # https://gitlab.com/ubports/development/core/trust-store/-/issues/2
    (lib.cmakeBool "TRUST_STORE_MIR_AGENT_ENABLED" false)
    (lib.cmakeBool "TRUST_STORE_ENABLE_DOC_GENERATION" true)
    # error: moving a temporary object prevents copy elision
    (lib.cmakeBool "ENABLE_WERROR" false)
  ];

  # Not working
  # - remote_agent_test cases using unix domain socket fail to do *something*, with std::system_error "Invalid argument" + follow-up "No such file or directory".
  #   potentially something broken/missing on our end
  # - dbus_test hangs indefinitely waiting for a std::future, not provicient enough to debug this.
  #   same hang on upstream CI
  doCheck = false;

  preCheck = ''
    export XDG_DATA_HOME=$TMPDIR
  '';

  # Starts & talks to DBus
  enableParallelChecking = false;

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "Common implementation of a trust store to be used by trusted helpers";
    homepage = "https://gitlab.com/ubports/development/core/trust-store";
    license = licenses.lgpl3Only;
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
    pkgConfigModules = [
      "trust-store"
    ];
  };
})
