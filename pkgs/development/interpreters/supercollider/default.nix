{ lib, stdenv, mkDerivation, fetchurl, cmake, runtimeShell
, pkg-config, alsa-lib, libjack2, libsndfile, fftw
, curl, gcc, libXt, qtbase, qttools, qtwebengine
, readline, qtwebsockets, useSCEL ? false, emacs
, gitUpdater, supercollider-with-plugins
, supercolliderPlugins, writeText, runCommand
}:

mkDerivation rec {
  pname = "supercollider";
  version = "3.13.0";

  src = fetchurl {
    url = "https://github.com/supercollider/supercollider/releases/download/Version-${version}/SuperCollider-${version}-Source.tar.bz2";
    sha256 = "sha256-D8Xbpbrq43+Qaa0oiFqkBcaiUwnjiGy+ERvTt8BVMc4=";
  };

  patches = [
    # add support for SC_DATA_DIR and SC_PLUGIN_DIR env vars to override compile-time values
    ./supercollider-3.12.0-env-dirs.patch
  ];

  postPatch = ''
    substituteInPlace common/sc_popen.cpp --replace '/bin/sh' '${runtimeShell}'
  '';

  strictDeps = true;

  nativeBuildInputs = [ cmake pkg-config qttools ];

  buildInputs = [ gcc libjack2 libsndfile fftw curl libXt qtbase qtwebengine qtwebsockets readline ]
    ++ lib.optional (!stdenv.isDarwin) alsa-lib
    ++ lib.optional useSCEL emacs;

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
      sclang-sc3-plugins = let
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
      in runCommand "sclang-sc3-plugins-test" { } ''
        timeout 60s env XDG_CONFIG_HOME="$(mktemp -d)" QT_QPA_PLATFORM=minimal ${supercollider-with-test-plugins}/bin/sclang ${testsc} >$out
      '';
    };
  };

  meta = with lib; {
    description = "Programming language for real time audio synthesis";
    homepage = "https://supercollider.github.io";
    changelog = "https://github.com/supercollider/supercollider/blob/Version-${version}/CHANGELOG.md";
    maintainers = with maintainers; [ lilyinstarlight ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
