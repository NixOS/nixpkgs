{ stdenv, fetchurl, cmake, pkgconfig, zlib, pcre, expat, sqlite, openssl, unixODBC, libmysqlclient }:

stdenv.mkDerivation rec {
  pname = "poco";

  version = "1.10.1";

  src = fetchurl {
    url = "https://pocoproject.org/releases/${pname}-${version}/${pname}-${version}-all.tar.gz";
    sha256 = "1jilzh0h6ik5lr167nax7q6nrpzxl99p11pkl202ig06pgh32nbz";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ zlib pcre expat sqlite openssl unixODBC libmysqlclient ];

  MYSQL_DIR = libmysqlclient;
  MYSQL_INCLUDE_DIR = "${MYSQL_DIR}/include/mysql";

  cmakeFlags = [
    "-DPOCO_UNBUNDLED=ON"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://pocoproject.org/";
    description = "Cross-platform C++ libraries with a network/internet focus";
    license = licenses.boost;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.unix;
  };
}
