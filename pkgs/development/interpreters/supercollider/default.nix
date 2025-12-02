{
  lib,
  stdenv,
  mkDerivation,
  fetchpatch,
  fetchurl,
  cmake,
  runtimeShell,
  pkg-config,
  alsa-lib,
  libjack2,
  libsndfile,
  fftw,
  curl,
  gcc,
  libsForQt5,
  libXt,
  qtbase,
  qttools,
  qtwebengine,
  readline,
  qtwebsockets,
  qtwayland,
  useSCEL ? false,
  emacs,
  gitUpdater,
  supercollider-with-plugins,
  supercolliderPlugins,
  writeText,
  runCommand,
  withWebengine ? false, # vulnerable, so disabled by default
}:

mkDerivation rec {
  pname = "supercollider";
  version = "3.13.1";

  src = fetchurl {
    url = "https://github.com/supercollider/supercollider/releases/download/Version-${version}/SuperCollider-${version}-Source.tar.bz2";
    sha256 = "sha256-aXnAFdqs/bVZMovoDV1P4mv2PtdFD2QuXHjnsnEyMSs=";
  };

  patches = [
    # add support for SC_DATA_DIR and SC_PLUGIN_DIR env vars to override compile-time values
    ./supercollider-3.12.0-env-dirs.patch

    # Fixes the build with CMake 4
    (fetchpatch {
      url = "https://github.com/supercollider/supercollider/commit/7d1f3fbe54e122889489a2f60bbc6cd6bb3bce28.patch";
      hash = "sha256-gyE0B2qTbj0ppbLlYTMa2ooY3FHzzIrdrpWYr81Hy1Y=";
    })
  ];

  postPatch = ''
    substituteInPlace common/sc_popen.cpp --replace '/bin/sh' '${runtimeShell}'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    libsForQt5.wrapQtAppsHook
  ]
  ++ lib.optionals useSCEL [ emacs ];

  buildInputs = [
    gcc
    libjack2
    libsndfile
    fftw
    curl
    libXt
    qtbase
    qtwebsockets
    qtwayland
    readline
  ]
  ++ lib.optional withWebengine qtwebengine
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) alsa-lib;

  hardeningDisable = [ "stackprotector" ];

  cmakeFlags = [
    "-DSC_WII=OFF"
    "-DSC_EL=${if useSCEL then "ON" else "OFF"}"
    (lib.cmakeBool "SC_USE_QTWEBENGINE" withWebengine)
  ];

  passthru = {
    updateScript = gitUpdater {
      url = "https://github.com/supercollider/supercollider.git";
      rev-prefix = "Version-";
      ignoredVersions = "rc|beta";
    };

    tests = {
      # test to make sure sclang runs and included plugins are successfully found
      sclang-sc3-plugins =
        let
          supercollider-with-test-plugins = supercollider-with-plugins.override {
            plugins = with supercolliderPlugins; [ sc3-plugins ];
          };
          testsc = writeText "test.sc" ''
            var err = 0;
            try {
            MdaPiano.name.postln;
            } {
            err = 1;
            };
            err.exit;
          '';
        in
        runCommand "sclang-sc3-plugins-test" { } ''
          timeout 60s env XDG_CONFIG_HOME="$(mktemp -d)" QT_QPA_PLATFORM=minimal ${supercollider-with-test-plugins}/bin/sclang ${testsc} >$out
        '';
    };
  };

  meta = with lib; {
    description = "Programming language for real time audio synthesis";
    homepage = "https://supercollider.github.io";
    changelog = "https://github.com/supercollider/supercollider/blob/Version-${version}/CHANGELOG.md";
    maintainers = [ ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
