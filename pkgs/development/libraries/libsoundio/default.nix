{ stdenv, fetchFromGitHub, cmake, alsaLib, libjack2-git, libpulseaudio }:

stdenv.mkDerivation rec {
  version = "1.0.2";
  name = "libsoundio-${version}";

  src = fetchFromGitHub {
    owner = "andrewrk";
    repo = "libsoundio";
    rev = "${version}";
    sha256 = "0zq8sy8m9zp2ji7qiwn932ivl5mw30kn97nip84ki8vc0lm7f8hx";
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
