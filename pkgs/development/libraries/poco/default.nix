{ lib, stdenv, fetchurl, fetchpatch, cmake, pkg-config, zlib, pcre, expat, sqlite, openssl, unixODBC, libmysqlclient }:

stdenv.mkDerivation rec {
  pname = "poco";

  version = "1.11.1";

  src = fetchurl {
    url = "https://pocoproject.org/releases/${pname}-${version}/${pname}-${version}-all.tar.gz";
    sha256 = "sha256-MczOYCAEcnAAO/tbDafirUMohMI9PNUJyG9HzzpeXSo=";
  };

  patches = [
    # Use GNUInstallDirs (https://github.com/pocoproject/poco/pull/3503)
    (fetchpatch {
      name = "use-gnuinstalldirs.patch";
      url = "https://github.com/pocoproject/poco/commit/16a2a74f6c28c6e6baca2ba26b4964b51d8a1b74.patch";
      sha256 = "sha256-mkemG8UemJEUQxae1trKakhnJFJW0AufDYFAbmnINbY=";
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

  buildInputs = [ unixODBC libmysqlclient ];
  propagatedBuildInputs = [ zlib pcre expat sqlite openssl ];

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
