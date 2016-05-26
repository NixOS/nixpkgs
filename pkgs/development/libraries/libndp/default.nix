{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libndp-1.6";

  src = fetchurl {
    url = "http://libndp.org/files/${name}.tar.gz";
    sha256 = "03mczwrxqbp54msafxzzyhaazkvjdwm2kipjkrb5xg8kw22glz8c";
  };

  meta = with stdenv.lib; {
    homepage = http://libndp.org/;
    description = "Library for Neighbor Discovery Protocol";
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
    license = licenses.lgpl21;
  };

}
