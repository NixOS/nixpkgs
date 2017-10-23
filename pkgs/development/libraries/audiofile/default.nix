{ stdenv, fetchurl, alsaLib, AudioUnit, CoreServices }:

stdenv.mkDerivation rec {
  name = "audiofile-0.3.6";

  buildInputs =
    stdenv.lib.optionals stdenv.isLinux [
      alsaLib
    ] ++ stdenv.lib.optionals stdenv.isDarwin [
      CoreServices AudioUnit
    ];

  src = fetchurl {
    url = "http://audiofile.68k.org/${name}.tar.gz";
    sha256 = "0rb927zknk9kmhprd8rdr4azql4gn2dp75a36iazx2xhkbqhvind";
  };

  patches = [ ./CVE-2015-7747.patch ./gcc-6.patch ];

  meta = with stdenv.lib; {
    description = "Library for reading and writing audio files in various formats";
    homepage    = http://www.68k.org/~michael/audiofile/;
    license     = licenses.lgpl21Plus;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
