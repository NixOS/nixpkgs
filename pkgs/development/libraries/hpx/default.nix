{ stdenv, fetchFromGitHub, boost, cmake, hwloc, gperftools, pkgconfig, python }:

stdenv.mkDerivation rec {
  name = "hpx-${version}";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "STEllAR-GROUP";
    repo = "hpx";
    rev = "${version}";
    sha256 = "1rliv42glns60bpmmvmgrglgmii42p8bmji349r6mr68f48iv4dx";
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
