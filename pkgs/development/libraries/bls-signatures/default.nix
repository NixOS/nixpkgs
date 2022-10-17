{ lib
, fetchFromGitHub
, stdenv
, cmake, gmp, libsodium, chia-relic
, substituteAll
}:

stdenv.mkDerivation {
  pname = "bls-signatures";
  version = "1.0.14";

  src = fetchFromGitHub {
    owner = "Chia-Network";
    repo = "bls-signatures";
    rev = "1.0.14";
    sha256 = "sha256-nUBvjCjhQ6GSO8GBZ0oFAGWoR+lclk/vgu2uJRzhYNw=";
    fetchSubmodules = true;
  };

patches = [
    # prevent CMake from trying to get libraries on the Internet
    (substituteAll {
      src = ./dont_fetch_dependencies.patch;
      relic = chia-relic;
      sodium = libsodium;
    })
  ];


  nativeBuildInputs = [ cmake gmp chia-relic ];

  buildInputs = [ libsodium ];

  enableParallelBuilding = true;
  cmakeFlags = [
    "-DBUILD_BLS_TESTS=false"
    "-DBUILD_BLS_BENCHMARKS=false"
    "-DBUILD_BLS_PYTHON_BINDINGS=false"
  ];

  meta = with lib; {
    homepage = "https://github.com/Chia-Network/bls-signatures";
    description = "BLS signatures in C++, using the relic toolkit BLS12-381";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abueide ];
  };
}
