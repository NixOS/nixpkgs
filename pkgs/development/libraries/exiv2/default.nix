{stdenv, fetchurl, zlib, expat}:

stdenv.mkDerivation rec {
  name = "exiv2-0.23";
  
  src = fetchurl {
    url = "http://www.exiv2.org/${name}.tar.gz";
    sha256 = "04bbg2cg6mgcyz435zamx37sp5zw44n2alb59ki1daz71f851yl1";
  };
  
  propagatedBuildInputs = [zlib expat];
  
# configure script finds zlib&expat but it thinks that they're in /usr
  configureFlags = "--with-zlib=${zlib} --with-expat=${expat}";

  meta = {
    homepage = http://www.exiv2.org/;
    description = "A library and command-line utility to manage image metadata";
    maintainers = [stdenv.lib.maintainers.urkud];
    platforms = stdenv.lib.platforms.all;
  };
}
