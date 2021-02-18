{ lib, stdenv, fetchFromGitHub, boost, cmake, hwloc, gperftools, pkg-config, python }:

stdenv.mkDerivation rec {
  pname = "hpx";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "STEllAR-GROUP";
    repo = "hpx";
    rev = version;
    sha256 = "sha256-Fkntfk5AaWtS1x0fXfLSWW/9tvKcCBi1COqgNxurPmk=";
  };

  buildInputs = [ boost hwloc gperftools ];
  nativeBuildInputs = [ cmake pkg-config python ];

  meta = {
    description = "C++ standard library for concurrency and parallelism";
    homepage = "https://github.com/STEllAR-GROUP/hpx";
    license = lib.licenses.boost;
    platforms = [ "x86_64-linux" ]; # lib.platforms.linux;
    maintainers = with lib.maintainers; [ bobakker ];
  };
}
