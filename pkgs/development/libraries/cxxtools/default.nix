{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "2.2.1";
  name = "cxxtools";

  src = fetchurl {
    url = "http://www.tntnet.org/download/${name}-${version}.tar.gz";
    sha256 = "0hp3qkyhidxkdf8qgkwrnqq5bpahink55mf0yz23rjd7rpbbdswc";
  };

  enableParallelBuilding = true;

  meta = {
    homepage = "http://www.tntnet.org/cxxtools.html";
    description = "Comprehensive C++ class library for Unix and Linux";
    platforms = stdenv.lib.platforms.linux ;
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.juliendehos ];
  };
}
