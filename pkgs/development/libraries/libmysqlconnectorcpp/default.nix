{ stdenv, fetchurl, cmake, boost, mysql }:

stdenv.mkDerivation rec {
  name = "libmysqlconnectorcpp-${version}";
  version = "1.1.7";

  src = fetchurl {
    url = "http://cdn.mysql.com/Downloads/Connector-C++/mysql-connector-c++-${version}.tar.gz";
    sha256 = "0qy7kxz8h1zswr50ysyl2cc9gy0ip2j7ikl714m7lq3gsay3ydav";
  };

  buildInputs = [ cmake boost mysql ];

  cmakeFlags = [ "-DMYSQL_LIB_DIR=${mysql}/lib" ];

  meta = {
    homepage = http://dev.mysql.com/downloads/connector/cpp/;
    description = "C++ library for connecting to mysql servers.";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
  };
}
