{stdenv, fetchurl, curl, libnxml, pkgconfig}:

stdenv.mkDerivation {
  name = "libmrss-1.0";

  src = fetchurl {
    url = "http://www.autistici.org/bakunin/libmrss/libmrss-0.19.2.tar.gz";
    sha256 = "02r1bgj8qlkn63xqfi5yq8y7wrilxcnkycaag8qskhg5ranic507";
  };

  buildInputs = [ curl libnxml pkgconfig ];

  meta = {
    homepage = http://code.google.com/p/feed-reader-lib;
    description = "C++ library designed to retrieve and parse web feeds such as RSS, ATOM and RDF";
    license = "MIT";

    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.viric ];
  };
}
