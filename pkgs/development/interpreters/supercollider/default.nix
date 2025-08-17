{
  lib,
  stdenv,
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
  libXt,
  qtbase,
  qttools,
  qtwebengine,
  qtwayland,
  readline,
  qtwebsockets,
  wrapQtAppsHook,
  useSCEL ? false,
  emacs,
  gitUpdater,
  supercollider-with-plugins,
  supercolliderPlugins,
  writeText,
  runCommand,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "supercollider";
  version = "3.14.0";

  src = fetchurl {
    url = "https://github.com/supercollider/supercollider/releases/download/Version-${finalAttrs.version}/SuperCollider-${finalAttrs.version}-Source.tar.bz2";
    hash = "sha256-q3EOhDdvXAgskvzqdGW4XTdZNPPafe7Vg0V6CkiwqRg=";
  };

  patches = [
    # add support for SC_DATA_DIR and SC_PLUGIN_DIR env vars to override compile-time values
    ./supercollider-3.14.0-env-dirs.patch
  ];

  postPatch = ''
    substituteInPlace common/sc_popen.cpp --replace-fail '/bin/sh' '${runtimeShell}'
  '';

  preFixup = ''
    qtWrapperArgs+=(--prefix PATH : $out/bin)
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    qtwebengine
    wrapQtAppsHook
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
    qtwebengine
    qtwebsockets
    readline
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    alsa-lib
    qtwayland
  ];

  hardeningDisable = [ "stackprotector" ];

  cmakeFlags = [
    "-DSC_WII=OFF"
    "-DSC_EL=${if useSCEL then "ON" else "OFF"}"
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
    changelog = "https://github.com/supercollider/supercollider/blob/Version-${finalAttrs.version}/CHANGELOG.md";
    mainProgram = "scide";
    maintainers = [ ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
})
