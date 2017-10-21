{ stdenv, fetchurl, cmake, pkgconfig, zlib, pcre, expat, sqlite, openssl, unixODBC, libmysql }:

stdenv.mkDerivation rec {
  name = "poco-${version}";

  version = "1.7.8";

  src = fetchurl {
    url = "https://pocoproject.org/releases/${name}/${name}-all.tar.gz";
    sha256 = "17y6kvj4qdpb3p1im8n9qfylfh4bd2xsvbpn24jv97x7f146nhjf";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ zlib pcre expat sqlite openssl unixODBC libmysql ];

  cmakeFlags = [
    "-DMYSQL_INCLUDE_DIR=${libmysql.dev}/include/mysql"
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
