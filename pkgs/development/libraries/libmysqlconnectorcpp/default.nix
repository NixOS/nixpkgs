{ lib, stdenv
, fetchurl
, cmake
, boost
, openssl
, mysql80
}:

stdenv.mkDerivation rec {
  pname = "libmysqlconnectorcpp";
  version = "8.0.28";

  src = fetchurl {
    url = "https://cdn.mysql.com/Downloads/Connector-C++/mysql-connector-c++-${version}-src.tar.gz";
    sha256 = "sha256-yyb+neBaO18e0ioZlCm2eR7OGEM+sEZeKnP89EWGQgs=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    boost
    openssl
    mysql80
  ];

  cmakeFlags = [
    # libmysqlclient is shared library
    "-DMYSQLCLIENT_STATIC_LINKING=false"
    # still needed for mysql-workbench
    "-DWITH_JDBC=true"
  ];

  meta = {
    homepage = "https://dev.mysql.com/downloads/connector/cpp/";
    description = "C++ library for connecting to mysql servers";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
  };
}
