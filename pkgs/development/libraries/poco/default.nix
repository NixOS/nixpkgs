{ stdenv, fetchurl, cmake, pkgconfig, zlib, pcre, expat, sqlite, openssl, unixODBC, mysql }:

stdenv.mkDerivation rec {
  name = "poco-${version}";

  version = "1.8.1";

  src = fetchurl {
    url = "https://pocoproject.org/releases/${name}/${name}-all.tar.gz";
    sha256 = "1pg48kk0354vsc6j2wnrk893l5xcsr3bjmkgykd3harcnvfqs7l8";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ zlib pcre expat sqlite openssl unixODBC mysql.connector-c ];

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
