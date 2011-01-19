{ fetchurl, stdenv, openssl, pkgconfig, zlib }:

stdenv.mkDerivation rec {
  name = "ucommon-4.0.5";

  src = fetchurl {
    url = mirror://gnu/commoncpp/ucommon-4.0.5.tar.gz;
    sha256 = "1h2xyb9s1xivpr5039jhhcqvd7ygn37si8yvmh5fd57n1y8by6vm";
  };

  buildInputs = [ pkgconfig openssl zlib ];

  doCheck = true;

  meta = {
    description = "C++ library to facilitate using C++ design patterns";
    homepage = http://www.gnutelephony.org/index.php/GNU_uCommon_C;
    license = "LGPLv3+";

    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.all;
  };
}
