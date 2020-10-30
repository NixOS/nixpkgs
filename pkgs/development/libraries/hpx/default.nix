{ stdenv, fetchFromGitHub, boost, cmake, hwloc, gperftools, pkgconfig, python }:

stdenv.mkDerivation rec {
  pname = "hpx";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "STEllAR-GROUP";
    repo = "hpx";
    rev = version;
    sha256 = "10hgjavhvn33y3k5j3l1326x13bxffghg2arxjrh7i7zd3qprfv5";
  };

  buildInputs = [ boost hwloc gperftools ];
  nativeBuildInputs = [ cmake pkgconfig python ];

  enableParallelBuilding = true;

  meta = {
    description = "C++ standard library for concurrency and parallelism";
    homepage = "https://github.com/STEllAR-GROUP/hpx";
    license = stdenv.lib.licenses.boost;
    platforms = [ "x86_64-linux" ]; # stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ bobakker ];
  };
}
