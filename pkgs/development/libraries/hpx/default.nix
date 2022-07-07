{ lib, stdenv, fetchFromGitHub, asio, boost, cmake, hwloc, gperftools, ninja
, pkg-config, python3 }:

stdenv.mkDerivation rec {
  pname = "hpx";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "STEllAR-GROUP";
    repo = "hpx";
    rev = version;
    sha256 = "1knx7kr8iw4b7nh116ygd00y68y84jjb4fj58jkay7n5qlrxh604";
  };

  buildInputs = [ asio boost hwloc gperftools ];
  nativeBuildInputs = [ cmake pkg-config python3 ];

  strictDeps = true;

  meta = {
    description = "C++ standard library for concurrency and parallelism";
    homepage = "https://github.com/STEllAR-GROUP/hpx";
    license = lib.licenses.boost;
    platforms = [ "x86_64-linux" ]; # lib.platforms.linux;
    maintainers = with lib.maintainers; [ bobakker ];
  };
}
