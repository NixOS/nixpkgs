{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libndp-1.5";

  src = fetchurl {
    url = "http://libndp.org/files/${name}.tar.gz";
    sha256 = "15f743hjc7yy2sv3hzvfc27s1gny4mh5aww59vn195fff2midwgs";
  };

  meta = with stdenv.lib; {
    homepage = http://libndp.org/;
    description = "Library for Neighbor Discovery Protocol";
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
    license = licenses.lgpl21;
  };

}