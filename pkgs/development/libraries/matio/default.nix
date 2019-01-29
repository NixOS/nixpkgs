{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "matio-1.5.13";
  src = fetchurl {
    url = "mirror://sourceforge/matio/${name}.tar.gz";
    sha256 = "1jz5760jn1cifr479znhmzksi8fp07j99jd8xdnxpjd79gsv5bgy";
  };

  meta = with stdenv.lib; {
    description = "A C library for reading and writing Matlab MAT files";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = [ maintainers.vbgl ];
    homepage = http://matio.sourceforge.net/;
  };
}
