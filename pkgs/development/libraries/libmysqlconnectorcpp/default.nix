{ stdenv, fetchurl, cmake, boost, mysql }:

stdenv.mkDerivation rec {
  name = "libmysqlconnectorcpp-${version}";
  version = "1.1.9";

  src = fetchurl {
    url = "http://cdn.mysql.com/Downloads/Connector-C++/mysql-connector-c++-${version}.tar.gz";
    sha256 = "1r6j17sy5816a2ld759iis2k6igc2w9p70y4nw9w3rd4d5x88c9y";
  };

  buildInputs = [ cmake boost mysql ];

  cmakeFlags = [ "-DMYSQL_LIB_DIR=${mysql}/lib" ];

  meta = {
    homepage = https://dev.mysql.com/downloads/connector/cpp/;
    description = "C++ library for connecting to mysql servers.";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
  };
}
