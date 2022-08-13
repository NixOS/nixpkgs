{ lib
, fetchFromGitHub
, stdenv
, cmake, gmp, libsodium
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
      relic_src = fetchFromGitHub {
        owner = "Chia-Network";
        repo = "relic";
        rev = "1d98e5abf3ca5b14fd729bd5bcced88ea70ecfd7";
        hash = "sha256-IfTD8DvTEXeLUoKe4Ejafb+PEJW5DV/VXRYuutwGQHU=";
      };
      sodium_src = fetchFromGitHub {
        owner = "AmineKhaldi";
        repo = "libsodium-cmake";
        rev = "f73a3fe1afdc4e37ac5fe0ddd401bf521f6bba65"; # pinned by upstream
        sha256 = "sha256-lGz7o6DQVAuEc7yTp8bYS2kwjzHwGaNjugDi1ruRJOA=";
        fetchSubmodules = true;
      };
    })
  ];


  nativeBuildInputs = [ cmake gmp ];

  buildInputs = [ libsodium ];

  CXXFLAGS = "-O3 -fmax-errors=1";
  cmakeFlags = [
    "-DARITH=easy"
    "-DBUILD_BLS_PYTHON_BINDINGS=false"
    "-DBUILD_BLS_TESTS=false"
    "-DBUILD_BLS_BENCHMARKS=false"
  ];

  meta = with lib; {
    homepage = "https://github.com/Chia-Network/bls-signatures";
    description = "BLS signatures in C++, using the relic toolkit BLS12-381";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abueide ];
  };
}
