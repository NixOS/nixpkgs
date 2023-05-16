{ lib, stdenv
, fetchurl
, cmake
, boost
, openssl
, mysql80
}:

stdenv.mkDerivation rec {
  pname = "libmysqlconnectorcpp";
<<<<<<< HEAD
  version = "8.0.33";

  src = fetchurl {
    url = "https://cdn.mysql.com/Downloads/Connector-C++/mysql-connector-c++-${version}-src.tar.gz";
    hash = "sha256-Fgz2iB+96b1GzRGq8Skwtna8bidYmsXHuknBlrl+BTs=";
=======
  version = "8.0.32";

  src = fetchurl {
    url = "https://cdn.mysql.com/Downloads/Connector-C++/mysql-connector-c++-${version}-src.tar.gz";
    hash = "sha256-+9t/IUQnYy9CPoS6dZS+H5IF6sgSjGsYVyA7L1RVzvM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
