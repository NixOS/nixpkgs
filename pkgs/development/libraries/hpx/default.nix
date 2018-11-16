{ stdenv, fetchFromGitHub, boost, cmake, hwloc, gperftools, pkgconfig, python }:

stdenv.mkDerivation rec {
  name = "hpx-${version}";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "STEllAR-GROUP";
    repo = "hpx";
    rev = "${version}";
    sha256 = "0xlhnycmpy2jgiqyzpwmkdrl6drf46ywdsl0qm4vksvjxqfgk9z3";
  };

  buildInputs = [ boost hwloc gperftools ];
  nativeBuildInputs = [ cmake pkgconfig python ];

  enableParallelBuilding = true;

  meta = {
    description = "C++ standard library for concurrency and parallelism";
    homepage = https://github.com/STEllAR-GROUP/hpx;
    license = stdenv.lib.licenses.boost;
    platforms = [ "x86_64-linux" ]; # stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ bobakker ];
  };
}
