{ lib
, stdenv
, fetchFromGitHub
, asio
, boost
, cmake
, hwloc
, gperftools
, pkg-config
, python3
}:

stdenv.mkDerivation rec {
  pname = "hpx";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "STEllAR-GROUP";
    repo = "hpx";
    rev = "v${version}";
    hash = "sha256-yrKG0n5BhrUNXjFWZRpb38/GYQlvMr0PSqUbhmZlgm0=";
  };

  propagatedBuildInputs = [ hwloc ];
  buildInputs = [ asio boost gperftools ];
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
