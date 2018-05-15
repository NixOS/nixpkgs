{ stdenv, fetchurl, cmake, pkgconfig, zlib, pcre, expat, sqlite, openssl, unixODBC, mysql }:

stdenv.mkDerivation rec {
  name = "poco-${version}";

  version = "1.9.0";

  src = fetchurl {
    url = "https://pocoproject.org/releases/${name}/${name}-all.tar.gz";
    sha256 = "11z1i0drbacs7c7d5virc3kz7wh79svd06iffh8j6giikl7vz1q3";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ zlib pcre expat sqlite openssl unixODBC mysql.connector-c ];

  MYSQL_DIR = mysql.connector-c;
  MYSQL_INCLUDE_DIR = "${MYSQL_DIR}/include/mysql";

  cmakeFlags = [
    "-DPOCO_UNBUNDLED=ON"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://pocoproject.org/;
    description = "Cross-platform C++ libraries with a network/internet focus";
    license = licenses.boost;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
