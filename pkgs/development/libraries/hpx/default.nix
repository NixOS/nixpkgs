{ stdenv, fetchFromGitHub, boost, cmake, hwloc, gperftools, pkgconfig, python }:

stdenv.mkDerivation rec {
  pname = "hpx";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "STEllAR-GROUP";
    repo = "hpx";
    rev = "${version}";
    sha256 = "0yzxb8520qh9rvzsa190yzx21jn3d8rl8ac5v01767ygd0413hfk";
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
