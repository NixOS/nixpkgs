{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libndp-1.4";

  src = fetchurl {
    url = "http://libndp.org/files/${name}.tar.gz";
    sha256 = "0pym5xxq3avg348q61xggwy05i0r2m4sj3mlwlpxfjq2xi3y42rs";
  };

  meta = with stdenv.lib; {
    homepage = http://libndp.org/;
    description = "Library for Neighbor Discovery Protocol";
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
    license = licenses.lgpl21;
  };

}