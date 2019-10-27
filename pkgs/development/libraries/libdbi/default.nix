{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libdbi-0.9.0";

  src = fetchurl {
    url = "mirror://sourceforge/libdbi/${name}.tar.gz";
    sha256 = "00s5ra7hdlq25iv23nwf4h1v3kmbiyzx0v9bhggjiii4lpf6ryys";
  };

  meta = with stdenv.lib; {
    homepage = http://libdbi.sourceforge.net/;
    description = "DB independent interface to DB";
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
