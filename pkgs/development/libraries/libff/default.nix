{ lib, stdenv, fetchFromGitHub, cmake, boost, gmp, openssl, pkg-config }:

stdenv.mkDerivation rec {
  pname = "libff";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "scipr-lab";
    repo = "libff";
    rev = "v${version}";
    sha256 = "0dczi829497vqlmn6n4fgi89bc2h9f13gx30av5z2h6ikik7crgn";
    fetchSubmodules = true;
  };

  cmakeFlags = [ "-DWITH_PROCPS=Off" ]
    ++ lib.optional stdenv.isAarch64 [ "-DCURVE=ALT_BN128" "-DUSE_ASM=OFF" ];

  # CMake is hardcoded to always build static library which causes linker
  # failure for Haskell applications depending on haskellPackages.hevm on macOS.
  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace libff/CMakeLists.txt --replace "STATIC" "SHARED"
  '';

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ boost gmp openssl ];

  meta = with lib; {
    description = "C++ library for Finite Fields and Elliptic Curves";
    changelog = "https://github.com/scipr-lab/libff/blob/develop/CHANGELOG.md";
    homepage = "https://github.com/scipr-lab/libff";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ arturcygan ];
  };
}
