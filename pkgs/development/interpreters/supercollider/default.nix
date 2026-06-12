{
  lib,
  stdenv,
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
  qt6,
  libxt,
  readline,
  useSCEL ? false,
  useQtWebEngine ? true,
  emacs,
  gitUpdater,
  supercollider-with-plugins,
  supercolliderPlugins,
  writeText,
  runCommand,
}:

stdenv.mkDerivation rec {
  pname = "supercollider";
  version = "3.14.1";

  src = fetchurl {
    url = "https://github.com/supercollider/supercollider/releases/download/Version-${version}/SuperCollider-${version}-Source.tar.bz2";
    sha256 = "sha256-7mQMaHd65pdoIGbOXEqLflbFsiPnbHnBO1vlOH7lW7I=";
  };

  patches = [
    # add support for Qt 6.11 in SuperCollider 3.14.1
    (fetchpatch {
      url = "https://github.com/supercollider/supercollider/commit/e997e47890a9cee137756dede664811a58dbf85a.patch";
      hash = "sha256-Koh5CwkedDEXwvSFyZSrdKyVIKpX7nPrIcsr2FXaejo=";
    })
  ];

  postPatch = ''
    substituteInPlace common/sc_popen.cpp --replace '/bin/sh' '${runtimeShell}'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.qttools
    qt6.wrapQtAppsHook
  ]
  ++ lib.optionals useSCEL [ emacs ];

  buildInputs = [
    gcc
    libjack2
    libsndfile
    fftw
    curl
    libxt
    qt6.qtbase
    qt6.qtwebsockets
    qt6.qtwayland
    qt6.qtwebengine
    readline
  ]
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) alsa-lib;

  hardeningDisable = [ "stackprotector" ];

  cmakeFlags = [
    "-DSC_WII=OFF"
    "-DSC_EL=${if useSCEL then "ON" else "OFF"}"
    (lib.cmakeBool "SC_USE_QTWEBENGINE" useQtWebEngine)
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

  meta = {
    description = "Programming language for real time audio synthesis";
    homepage = "https://supercollider.github.io";
    changelog = "https://github.com/supercollider/supercollider/blob/Version-${version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [
      pretentiousUsername
    ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    hasNoMaintainersButDependents = true;
  };
}
