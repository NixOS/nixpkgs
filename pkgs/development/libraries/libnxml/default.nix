{stdenv, fetchurl, curl}:

stdenv.mkDerivation {
  name = "libnxml-0.18.3";

  src = fetchurl {
    url = "http://www.autistici.org/bakunin/libnxml/libnxml-0.18.3.tar.gz";
    sha256 = "0ix5b9bxd7r517vhgcxwdviq4m0g0pq46s5g3h04gcqnpbin150g";
  };

  buildInputs = [ curl ];

  meta = {
    homepage = http://www.autistici.org/bakunin/libnxml/;
    description = "C library for parsing, writing and creating XML 1.0 and 1.1 files or streams";
    license = stdenv.lib.licenses.lgpl2;

    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.viric ];
  };
}
