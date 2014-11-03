{stdenv, fetchurl, curl, libnxml, pkgconfig}:

stdenv.mkDerivation {
  name = "libmrss-0.19.2";

  src = fetchurl {
    url = "http://www.autistici.org/bakunin/libmrss/libmrss-0.19.2.tar.gz";
    sha256 = "02r1bgj8qlkn63xqfi5yq8y7wrilxcnkycaag8qskhg5ranic507";
  };

  buildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ curl libnxml ];

  meta = {
    homepage = http://www.autistici.org/bakunin/libmrss/doc;
    description = "C library for parsing, writing and creating RSS/ATOM files or streams";
    license = stdenv.lib.licenses.lgpl2;

    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.viric ];
  };
}
