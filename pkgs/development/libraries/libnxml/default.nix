{lib, stdenv, fetchurl, curl}:

stdenv.mkDerivation rec {
  pname = "libnxml";
  version = "0.18.3";

  src = fetchurl {
    url = "https://www.autistici.org/bakunin/libnxml/libnxml-${version}.tar.gz";
    sha256 = "0ix5b9bxd7r517vhgcxwdviq4m0g0pq46s5g3h04gcqnpbin150g";
  };

  buildInputs = [ curl ];

  meta = {
    homepage = "https://www.autistici.org/bakunin/libnxml/";
    description = "C library for parsing, writing and creating XML 1.0 and 1.1 files or streams";
    license = lib.licenses.lgpl2;

    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.viric ];
  };
}
