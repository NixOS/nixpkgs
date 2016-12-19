{ stdenv, fetchurl, cxxtools, zlib, openssl, zip }:

stdenv.mkDerivation rec {
  version = "2.2.1";
  name = "tntnet";
  src = fetchurl {
    url = "http://www.tntnet.org/download/tntnet-${version}.tar.gz";
    sha256 = "08bmak9mpbamwwl3h9p8x5qzwqlm9g3jh70y0ml5hk7hiv870cf8";
  };

  buildInputs = [ cxxtools zlib openssl zip ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "http://www.tntnet.org/tntnet.html";
    description = "Web server which allows users to develop web applications using C++";
    platforms = platforms.linux ;
    license = licenses.lgpl21;
    maintainers = [ maintainers.juliendehos ];
  };
}
