{ stdenv, fetchFromGitHub, autoconf, automake, libtool, libjack2,  alsaLib, rtmidi }:

stdenv.mkDerivation rec {
  version = "5.1.0";
  name = "rtaudio-${version}";

  src = fetchFromGitHub {
    owner = "thestk";
    repo = "rtaudio";
    rev = "${version}";
    sha256 = "1pglnjz907ajlhnlnig3p0sx7hdkpggr8ss7b3wzf1lykzgv9l52";
  };

  enableParallelBuilding = true;

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
