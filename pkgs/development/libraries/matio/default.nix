{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "matio-1.5.9";
  src = fetchurl {
    url = "mirror://sourceforge/matio/${name}.tar.gz";
    sha256 = "0p60c3wdj4w7v7hzdc0iivciq4hwxzhhx0zq8gpv9i8yhdjzkdxy";
  };

  meta = with stdenv.lib; {
    description = "A C library for reading and writing Matlab MAT files";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = [ maintainers.vbgl ];
    homepage = http://matio.sourceforge.net/;
  };
}
