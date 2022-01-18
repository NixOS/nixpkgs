{ lib, stdenv, fetchurl, fetchpatch, cmake, pkg-config, zlib, pcre, expat, sqlite, openssl, unixODBC, libmysqlclient }:

stdenv.mkDerivation rec {
  pname = "poco";

  version = "1.10.1";

  src = fetchurl {
    url = "https://pocoproject.org/releases/${pname}-${version}/${pname}-${version}-all.tar.gz";
    sha256 = "1jilzh0h6ik5lr167nax7q6nrpzxl99p11pkl202ig06pgh32nbz";
  };

  patches = [
    # Use GNUInstallDirs (https://github.com/pocoproject/poco/pull/3105)
    (fetchpatch {
      name = "use-gnuinstalldirs.patch";
      url = "https://github.com/pocoproject/poco/commit/9e8f84dff4575f01be02e0b07364efd1561ce66c.patch";
      sha256 = "1bj4i93gxr7pwx33bfyhg20ad4ak1rbxkrlpsgzk7rm6mh0mld26";
      # Files not included in release tarball
      excludes = [
        "Encodings/Compiler/CMakeLists.txt"
        "PocoDoc/CMakeLists.txt"
        "NetSSL_Win/CMakeLists.txt"
        "PDF/CMakeLists.txt"
        "SevenZip/CMakeLists.txt"
        "ApacheConnector/CMakeLists.txt"
        "CppParser/CMakeLists.txt"
      ];
    })
  ];

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ openssl unixODBC libmysqlclient ];
  propagatedBuildInputs = [ zlib pcre expat sqlite ];

  outputs = [ "out" "dev" ];

  MYSQL_DIR = libmysqlclient;
  MYSQL_INCLUDE_DIR = "${MYSQL_DIR}/include/mysql";

  cmakeFlags = [
    "-DPOCO_UNBUNDLED=ON"
  ];

  meta = with lib; {
    homepage = "https://pocoproject.org/";
    description = "Cross-platform C++ libraries with a network/internet focus";
    license = licenses.boost;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.unix;
  };
}
