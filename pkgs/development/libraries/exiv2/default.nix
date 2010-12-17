{stdenv, fetchurl, zlib, expat}:

stdenv.mkDerivation rec {
  name = "exiv2-0.21";
  
  src = fetchurl {
    url = "http://www.exiv2.org/${name}.tar.gz";
    sha256 = "1r9phzb1h9v8smw1pix2k9lyr44n4nyba15x7qh45c0pwsjdf9yq";
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
