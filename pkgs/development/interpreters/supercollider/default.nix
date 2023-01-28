{ lib, stdenv, mkDerivation, fetchurl, fetchpatch, cmake
, pkg-config, alsa-lib, libjack2, libsndfile, fftw
, curl, gcc, libXt, qtbase, qttools, qtwebengine
, readline, qtwebsockets, useSCEL ? false, emacs
, supercollider-with-plugins, supercolliderPlugins
, writeText, runCommand
}:

mkDerivation rec {
  pname = "supercollider";
  version = "3.12.2";

  src = fetchurl {
    url = "https://github.com/supercollider/supercollider/releases/download/Version-${version}/SuperCollider-${version}-Source.tar.bz2";
    sha256 = "sha256-1QYorCgSwBK+SVAm4k7HZirr1j+znPmVicFmJdvO3g4=";
  };

  patches = [
    # add support for SC_DATA_DIR and SC_PLUGIN_DIR env vars to override compile-time values
    ./supercollider-3.12.0-env-dirs.patch

    # fix issue with libsndfile >=1.1.0
    (fetchpatch {
      url = "https://github.com/supercollider/supercollider/commit/b9dd70c4c8d61c93d7a70645e0bd18fa76e6834e.patch";
      hash = "sha256-6FhEHyY0rnE6d7wC+v0U9K+L0aun5LkTqaEFhr3eQNw=";
    })
  ];

  nativeBuildInputs = [ cmake pkg-config qttools ];

  buildInputs = [ gcc libjack2 libsndfile fftw curl libXt qtbase qtwebengine qtwebsockets readline ]
    ++ lib.optional (!stdenv.isDarwin) alsa-lib
    ++ lib.optional useSCEL emacs;

  hardeningDisable = [ "stackprotector" ];

  cmakeFlags = [
    "-DSC_WII=OFF"
    "-DSC_EL=${if useSCEL then "ON" else "OFF"}"
  ];

  passthru.tests = {
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
    in runCommand "sclang-sc3-plugins-test" {} ''
      timeout 60s env XDG_CONFIG_HOME="$(mktemp -d)" QT_QPA_PLATFORM=minimal ${supercollider-with-test-plugins}/bin/sclang ${testsc} >$out
    '';
  };

  meta = with lib; {
    description = "Programming language for real time audio synthesis";
    homepage = "https://supercollider.github.io";
    maintainers = with maintainers; [ lilyinstarlight ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
