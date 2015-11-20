{ stdenv, fetchFromGitHub, cmake, alsaLib, libjack2-git, libpulseaudio }:

stdenv.mkDerivation rec {
  version = "1.0.3";
  name = "libsoundio-${version}";

  src = fetchFromGitHub {
    owner = "andrewrk";
    repo = "libsoundio";
    rev = "${version}";
    sha256 = "0xnv0rsan57i07ky823jczylbcpbzjk6j06fw9x0md65arcgcqfy";
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
