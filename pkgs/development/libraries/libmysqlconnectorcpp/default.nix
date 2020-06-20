{ stdenv
, fetchurl
, cmake
, boost
, openssl
, mysql80
}:

stdenv.mkDerivation rec {
  pname = "libmysqlconnectorcpp";
  version = "8.0.20";

  src = fetchurl {
    url = "https://cdn.mysql.com/Downloads/Connector-C++/mysql-connector-c++-${version}-src.tar.gz";
    sha256 = "1jrrbfy6sw4pni72c1hgvchx1zzfpnamp34sjnv82mlvsp8ypsjh";
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
    description = "C++ library for connecting to mysql servers.";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
  };
}
