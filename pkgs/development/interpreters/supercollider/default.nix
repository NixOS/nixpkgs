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
      # Check both language classes and server UGens, without an audio device.
      sclang-sc3-plugins =
        let
          supercollider-with-test-plugins = supercollider-with-plugins.override {
            plugins = with supercolliderPlugins; [ sc3-plugins ];
          };
        in
        runCommand "sclang-sc3-plugins-test"
          {
            QT_QPA_PLATFORM = "offscreen";
          }
          ''
            export XDG_CONFIG_HOME="$TMPDIR/config"
            export XDG_DATA_HOME="$TMPDIR/data"
            export XDG_CACHE_HOME="$TMPDIR/cache"
            mkdir -p "$out"
            timeout 60s ${supercollider-with-test-plugins}/bin/sclang \
              ${./tests/sc3-plugins.scd} "$out" 2>&1 | tee "$out/log"
            grep -Fq 'SC3 plugins rendered successfully' "$out/log"
            if grep -E 'ERROR|FAILURE|duplicate' "$out/log"; then
              exit 1
            fi
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
  };
}
