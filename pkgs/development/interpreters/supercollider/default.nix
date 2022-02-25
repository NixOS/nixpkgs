{ lib, stdenv, mkDerivation, fetchurl, cmake
, pkg-config, alsa-lib, libjack2, libsndfile, fftw
, curl, gcc, libXt, qtbase, qttools, qtwebengine
, readline, qtwebsockets, useSCEL ? false, emacs
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

  meta = with lib; {
    description = "Programming language for real time audio synthesis";
    homepage = "https://supercollider.github.io";
    maintainers = with maintainers; [ lilyinstarlight ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
