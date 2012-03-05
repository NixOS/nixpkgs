{stdenv, fetchurl, zlib, expat}:

stdenv.mkDerivation rec {
  name = "exiv2-0.22";
  
  src = fetchurl {
    url = "http://www.exiv2.org/${name}.tar.gz";
    sha256 = "0ynf4r4fqijaa9yb0wfddk0a151p8cbcqxab54dyhc1xk83saf6k";
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
