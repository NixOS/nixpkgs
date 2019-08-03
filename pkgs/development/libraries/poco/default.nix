{ stdenv, fetchurl, cmake, pkgconfig, zlib, pcre, expat, sqlite, openssl, unixODBC, mysql }:

stdenv.mkDerivation rec {
  name = "poco-${version}";

  version = "1.9.2";

  src = fetchurl {
    url = "https://pocoproject.org/releases/${name}/${name}-all.tar.gz";
    sha256 = "0jkbxw6z8l7zpr7bh2xcyzk8a5apzyz4ranhl66gxna1ay0gpzvd";
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
