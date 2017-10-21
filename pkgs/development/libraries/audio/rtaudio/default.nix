{ stdenv, fetchFromGitHub, autoconf, automake, libtool, libjack2,  alsaLib, rtmidi }:

stdenv.mkDerivation rec {
  version = "4.1.2";
  name = "rtaudio-${version}";

  src = fetchFromGitHub {
    owner = "thestk";
    repo = "rtaudio";
    rev = "${version}";
    sha256 = "09j84l9l3q0g238z5k89rm8hgk0i1ir8917an7amq474nwjp80pq";
  };

  buildInputs = [ autoconf automake libtool libjack2 alsaLib rtmidi ];

  preConfigure = ''
    ./autogen.sh --no-configure
    ./configure
  '';

  meta = {
    description = "A set of C++ classes that provide a cross platform API for realtime audio input/output";
    homepage =  http://www.music.mcgill.ca/~gary/rtaudio/;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
