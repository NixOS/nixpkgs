{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "2.2.1";
  pname = "cxxtools";

  src = fetchurl {
    url = "http://www.tntnet.org/download/${pname}-${version}.tar.gz";
    sha256 = "0hp3qkyhidxkdf8qgkwrnqq5bpahink55mf0yz23rjd7rpbbdswc";
  };

  configureFlags = lib.optional stdenv.isAarch64 "--with-atomictype=pthread";

  enableParallelBuilding = true;

  meta = {
    homepage = "http://www.tntnet.org/cxxtools.html";
    description = "Comprehensive C++ class library for Unix and Linux";
    platforms = lib.platforms.linux ;
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.juliendehos ];
  };
}
