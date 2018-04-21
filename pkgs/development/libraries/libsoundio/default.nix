{ stdenv, fetchFromGitHub, cmake, alsaLib, libjack2, libpulseaudio, AudioUnit }:

stdenv.mkDerivation rec {
  version = "1.1.0";
  name = "libsoundio-${version}";

  src = fetchFromGitHub {
    owner = "andrewrk";
    repo = "libsoundio";
    rev = "${version}";
    sha256 = "0mw197l4bci1cjc2z877gxwsvk8r43dr7qiwci2hwl2cjlcnqr2p";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libjack2 libpulseaudio ]
    ++ stdenv.lib.optional stdenv.isLinux alsaLib
    ++ stdenv.lib.optional stdenv.isDarwin AudioUnit;

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-Wno-strict-prototypes";

  meta = with stdenv.lib; {
    description = "Cross platform audio input and output";
    homepage = http://libsound.io/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.andrewrk ];
  };
}
