{ stdenv, fetchFromGitHub, autoconf, automake, libtool, libjack2, alsaLib, pkgconfig }:

stdenv.mkDerivation rec {
  version = "4.0.0";
  name = "rtmidi-${version}";

  src = fetchFromGitHub {
    owner = "thestk";
    repo = "rtmidi";
    rev = "${version}";
    sha256 = "1g31p6a96djlbk9jh5r4pjly3x76lhccva9hrw6xzdma8dsjzgyq";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ autoconf automake libtool libjack2 alsaLib ];

  preConfigure = ''
    ./autogen.sh --no-configure
    ./configure
  '';

  meta = {
    description = "A set of C++ classes that provide a cross platform API for realtime MIDI input/output";
    homepage =  http://www.music.mcgill.ca/~gary/rtmidi/;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
