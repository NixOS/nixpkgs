{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "matio-1.5.10";
  src = fetchurl {
    url = "mirror://sourceforge/matio/${name}.tar.gz";
    sha256 = "00dmg2f5k2xgakp7l0lganz122b1agazw5d899xci35xrqc9j821";
  };

  meta = with stdenv.lib; {
    description = "A C library for reading and writing Matlab MAT files";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = [ maintainers.vbgl ];
    homepage = http://matio.sourceforge.net/;
  };
}
