{stdenv, fetchurl, libtool, openssl, pkgconfig}:

stdenv.mkDerivation rec {
  name = "libp11-0.2.7";
  
  src = fetchurl {
    url = "http://www.opensc-project.org/files/libp11/${name}.tar.gz";
    sha256 = "0kaz5qafaxm0ycywmajl166c29fh9cz89b8i043jqsbxlpzf4hdp";
  };
  
  buildInputs = [ libtool openssl pkgconfig ];

  meta = {
    homepage = http://www.opensc-project.org/libp11/;
    license = "LGPL";
    description = "Small layer on top of PKCS#11 API to make PKCS#11 implementations easier";
  };
}
