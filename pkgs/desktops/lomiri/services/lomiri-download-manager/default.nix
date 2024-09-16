{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, gitUpdater
, testers
, boost
, cmake
, cmake-extras
, dbus
, dbus-test-runner
# Needs qdoc, https://github.com/NixOS/nixpkgs/pull/245379
, withDocumentation ? false
, doxygen
, glog
, graphviz
, gtest
, lomiri-api
, pkg-config
, python3
, qtbase
, qtdeclarative
, validatePkgConfig
, wrapQtAppsHook
, xvfb-run
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-download-manager";
  version = "0.1.3";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-download-manager";
    rev = finalAttrs.version;
    hash = "sha256-LhhO/zZ4wNiRd235NB2b08SQcCZt1awN/flcsLs2m8U=";
  };

  outputs = [
    "out"
    "dev"
  ] ++ lib.optionals withDocumentation [
    "doc"
  ];

  patches = [
    # This change seems incomplete, potentially breaks things on systems that don't use AppArmor mediation
    # https://gitlab.com/ubports/development/core/lomiri-download-manager/-/merge_requests/24#note_1746801673
    (fetchpatch {
      name = "0001-lomiri-download-manager-Revert-Drop-GetConnectionAppArmorSecurityContext.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-download-manager/-/commit/2367f3dff852b69457b1a65a487cb032c210569f.patch";
      revert = true;
      hash = "sha256-xS0Wz6d+bZWj/kDGK2WhOduzyP4Rgz3n9n2XY1Zu5hE=";
    })
  ];

  postPatch = ''
    # Substitute systemd's prefix in pkg-config call
    substituteInPlace CMakeLists.txt \
      --replace-fail 'pkg_get_variable(SYSTEMD_USER_DIR systemd systemduserunitdir)' 'pkg_get_variable(SYSTEMD_USER_DIR systemd systemduserunitdir DEFINE_VARIABLES prefix=''${CMAKE_INSTALL_PREFIX})' \
      --replace-fail "\''${CMAKE_INSTALL_LIBDIR}/qt5/qml" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"

    # For our automatic pkg-config output patcher to work, prefix must be used here
    substituteInPlace src/{common/public,downloads/client,downloads/common,uploads/common}/*.pc.in \
      --replace-fail 'libdir=''${exec_prefix}' 'libdir=''${prefix}'
    substituteInPlace src/downloads/client/lomiri-download-manager-client.pc.in \
      --replace-fail 'includedir=''${exec_prefix}' 'includedir=''${prefix}'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    validatePkgConfig
    wrapQtAppsHook
  ] ++ lib.optionals withDocumentation [
    doxygen
    graphviz
  ];

  buildInputs = [
    boost
    cmake-extras
    glog
    lomiri-api
    qtbase
    qtdeclarative
  ];

  nativeCheckInputs = [
    dbus
    dbus-test-runner
    python3
    xvfb-run
  ];

  checkInputs = [
    gtest
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_DOC" withDocumentation)
    # Deprecation warnings on Qt 5.15
    # https://gitlab.com/ubports/development/core/lomiri-download-manager/-/issues/1
    (lib.cmakeBool "ENABLE_WERROR" false)
  ];

  makeTargets = [
    "all"
  ] ++ lib.optionals withDocumentation [
    "doc"
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # xvfb tests are flaky on xvfb shutdown when parallelised
  enableParallelChecking = false;

  preCheck = ''
    export HOME=$TMPDIR # temp files in home
    export QT_PLUGIN_PATH=${lib.getBin qtbase}/${qtbase.qtPluginPrefix} # xcb platform & sqlite driver
  '';

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    description = "Performs uploads and downloads from a centralized location";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-download-manager";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-download-manager/-/blob/${finalAttrs.version}/ChangeLog";
    license = licenses.lgpl3Only;
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
    pkgConfigModules = [
      "ldm-common"
      "lomiri-download-manager-client"
      "lomiri-download-manager-common"
      "lomiri-upload-manager-common"
    ];
  };
})
