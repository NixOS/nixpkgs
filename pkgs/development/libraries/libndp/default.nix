{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libndp-1.7";

  src = fetchurl {
    url = "http://libndp.org/files/${name}.tar.gz";
    sha256 = "1dlinhl39va00v55qygjc9ap77yqf7xvn4rwmvdr49xhzzxhlj1c";
  };

  meta = with stdenv.lib; {
    homepage = "http://libndp.org/";
    description = "Library for Neighbor Discovery Protocol";
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
    license = licenses.lgpl21;
  };

}
