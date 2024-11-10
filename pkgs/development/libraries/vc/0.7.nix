{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "Vc";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "VcDevel";
    repo = "Vc";
    rev = version;
    sha256 = "190s4r2n3jsivl4j2m288j3rqmgjj6gl308hi9mzwyhcfn17q8br";
  };

  # Avoid requesting an unreasonable intrinsic
  patches = lib.optional stdenv.cc.isClang ./vc_0_7_clang_fix.patch;

  nativeBuildInputs = [ cmake ];

  postPatch = ''
    sed -i '/OptimizeForArchitecture()/d' cmake/VcMacros.cmake
    sed -i '/AutodetectHostArchitecture()/d' print_target_architecture.cmake
  '';

  meta = with lib; {
    description = "Library for multiprecision complex arithmetic with exact rounding";
    homepage = "https://github.com/VcDevel/Vc";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ abbradar ];
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) || (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
  };
}
