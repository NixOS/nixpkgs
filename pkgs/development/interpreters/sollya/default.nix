{ lib
, stdenv
, fetchurl
, gmp
, mpfr
, mpfi
, libxml2
, fplll
}:

stdenv.mkDerivation rec {
  pname = "sollya";
  version = "7.0";

  src = fetchurl {
    url = "https://www.sollya.org/releases/sollya-${version}/sollya-${version}.tar.gz";
    sha256 = "0amrxg7567yy5xqpgchxggjpfr11xyl27vy29c7vlh7v8a17nj1h";
  };

  buildInputs = [ gmp mpfr mpfi libxml2 fplll ];

  meta = with lib; {
    description = "A tool environment for safe floating-point code development";
    homepage = "https://www.sollya.org/";
    license = licenses.cecill-c;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
