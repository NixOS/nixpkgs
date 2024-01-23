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
, withDocumentation ? true
, doxygen
, glog
, graphviz
, gtest
, lomiri-api
, pkg-config
, python3
, qtbase
, qtdeclarative
, wrapQtAppsHook
, xvfb-run
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-download-manager";
  version = "0.1.2";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-download-manager";
    rev = finalAttrs.version;
    hash = "sha256-a9C+hactBMHMr31E+ImKDPgpzxajy1klkjDcSEkPHqI=";
  };

  outputs = [
    "out"
    "dev"
  ] ++ lib.optionals withDocumentation [
    "doc"
  ];

  patches = [
    # Remove when version > 0.1.2
    (fetchpatch {
      name = "0001-lomiri-download-manager-Make-documentation-build-optional.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-download-manager/-/commit/32d7369714c01bd425af9c6de5bdc04399a12e0a.patch";
      hash = "sha256-UztcBAAFXDX2j0X5D3kMp9q0vFm3/PblUAKPJ5nZyiY=";
    })

    # Remove when version > 0.1.2
    (fetchpatch {
      name = "0002-lomiri-download-manager-Upgrade-C++-standard-to-C++17.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-download-manager/-/commit/a6bc7ae80f2ff4c4743978c6c694149707d9d2e2.patch";
      hash = "sha256-iA1sZhHI8Osgo1ofL5RTqgVzUG32zx0dU/28qcEqmQc=";
    })

    # Remove when version > 0.1.2
    (fetchpatch {
      name = "0003-lomiri-download-manager-Bump-version-make-Werror-and-tests-optional.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-download-manager/-/commit/73ec04c429e5285f05dd72d5bb9720ba6ff31be2.patch";
      hash = "sha256-0BrJSKCvUhITwfln05OrHgHEpldbgBoh4rivAvw+qrc=";
    })

    # Remove when version > 0.1.2
    (fetchpatch {
      name = "0004-lomiri-download-manager-Use-GNUInstallDirs-variables-for-more-install-destinations.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-download-manager/-/commit/5d40daf053de62150aa5ee618285e415d7d3f1c8.patch";
      hash = "sha256-r5fpiJkZkDsYX9fcX5JuPsE/qli9z5/DatmGJ9/QauU=";
    })
  ];

  postPatch = ''
    # fetchpatch strips renames
    # Remove when version > 0.1.2
    for service in src/{uploads,downloads}/daemon/{lomiri-*-manager,lomiri-*-manager-systemd,com.lomiri.*}.service; do
      mv "$service" "$service".in
    done

    # pkg_get_variable doesn't let us substitute prefix pkg-config variable from systemd
    substituteInPlace CMakeLists.txt \
      --replace 'pkg_get_variable(SYSTEMD_USER_DIR systemd systemduserunitdir)' 'set(SYSTEMD_USER_DIR "${placeholder "out"}/lib/systemd/user")' \
      --replace "\''${CMAKE_INSTALL_LIBDIR}/qt5/qml" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
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
    "-DENABLE_DOC=${lib.boolToString withDocumentation}"
    # Deprecation warnings on Qt 5.15
    # https://gitlab.com/ubports/development/core/lomiri-download-manager/-/issues/1
    "-DENABLE_WERROR=OFF"
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
