{ lib, stdenv, fetchFromGitHub, boost, cmake, hwloc, gperftools, pkg-config, python }:

stdenv.mkDerivation rec {
  pname = "hpx";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "STEllAR-GROUP";
    repo = "hpx";
    rev = version;
    sha256 = "1ld2k00500p107jarw379hsd1nlnm33972nv9c3ssfq619bj01c9";
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
