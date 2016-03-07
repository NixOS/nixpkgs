{ stdenv, fetchFromGitHub, cmake, alsaLib, libjack2-git, libpulseaudio }:

stdenv.mkDerivation rec {
  version = "1.1.0";
  name = "libsoundio-${version}";

  src = fetchFromGitHub {
    owner = "andrewrk";
    repo = "libsoundio";
    rev = "${version}";
    sha256 = "0mw197l4bci1cjc2z877gxwsvk8r43dr7qiwci2hwl2cjlcnqr2p";
  };

  buildInputs = [ cmake alsaLib libjack2-git libpulseaudio ];

  meta = with stdenv.lib; {
    description = "Cross platform audio input and output";
    homepage = http://libsound.io/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.andrewrk ];
  };
}
