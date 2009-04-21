{stdenv, fetchurl, zlib}:

stdenv.mkDerivation rec {
  name = "exiv2-0.18";
  
  src = fetchurl {
    url = "http://www.exiv2.org/${name}.tar.gz";
    sha256 = "1kg4bdlcqqhw9gcfs68i55sz4hvlf94xxxmqb255hhvhfj692rz5";
  };
  
  buildInputs = [zlib];
  
  configureFlags = "--with-zlib=${zlib} --disable-xmp";

  meta = {
    homepage = http://www.exiv2.org/;
    description = "A library and command-line utility to manage image metadata";
  };
}
