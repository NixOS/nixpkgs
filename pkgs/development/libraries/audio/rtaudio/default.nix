{ stdenv, fetchFromGitHub, autoconf, automake, libtool, libjack2,  alsaLib, pulseaudio, rtmidi }:

stdenv.mkDerivation rec {
  version = "5.1.0";
  pname = "rtaudio";

  src = fetchFromGitHub {
    owner = "thestk";
    repo = "rtaudio";
    rev = version;
    sha256 = "1pglnjz907ajlhnlnig3p0sx7hdkpggr8ss7b3wzf1lykzgv9l52";
  };

  enableParallelBuilding = true;

  buildInputs = [ autoconf automake libtool libjack2 alsaLib pulseaudio rtmidi ];

  preConfigure = ''
    ./autogen.sh --no-configure
    ./configure
  '';

  meta = with stdenv.lib; {
    description = "A set of C++ classes that provide a cross platform API for realtime audio input/output";
    homepage =  http://www.music.mcgill.ca/~gary/rtaudio/;
    license = licenses.mit;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.unix;
  };
}
