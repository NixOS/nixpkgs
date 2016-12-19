{ stdenv, fetchFromGitHub, autoconf, automake, libtool, libjack2, alsaLib, pkgconfig }:

stdenv.mkDerivation rec {
  version = "2.1.1";
  name = "rtmidi-${version}";

  src = fetchFromGitHub {
    owner = "thestk";
    repo = "rtmidi";
    rev = "${version}";
    sha256 = "11pl45lp8sq5xkpipwk622w508nw0qcxr03ibicqn1lsws0hva96";
  };

  buildInputs = [ autoconf automake libtool libjack2 alsaLib pkgconfig ];

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
