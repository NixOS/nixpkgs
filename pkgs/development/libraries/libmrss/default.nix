{lib, stdenv, fetchurl, curl, libnxml, pkg-config}:

stdenv.mkDerivation rec {
  pname = "libmrss";
  version = "0.19.2";

  src = fetchurl {
    url = "https://www.autistici.org/bakunin/libmrss/libmrss-${version}.tar.gz";
    sha256 = "02r1bgj8qlkn63xqfi5yq8y7wrilxcnkycaag8qskhg5ranic507";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ curl libnxml ];

  meta = {
    homepage = "http://www.autistici.org/bakunin/libmrss/doc";
    description = "C library for parsing, writing and creating RSS/ATOM files or streams";
    license = lib.licenses.lgpl2;

    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.viric ];
  };
}
