{ stdenv, fetchurl, alsaLib }:

stdenv.mkDerivation rec {
  name = "audiofile-0.3.3";

  buildInputs = stdenv.lib.optional (!stdenv.isDarwin) alsaLib;

  src = fetchurl {
    url = "http://audiofile.68k.org/${name}.tar.gz";
    sha256 = "1qm7z0g1d9rcxi1m87slgdi0rhl94g13dx3d2b05dilghwpgjjgq";
  };

  meta = with stdenv.lib; {
    description = "Library for reading and writing audio files in various formats";
    homepage    = http://www.68k.org/~michael/audiofile/; 
    license     = licenses.lgpl21Plus;
    maintainers = with maintainers; [ lovek323 shlevy ];
    platforms   = platforms.unix;
  };
}
