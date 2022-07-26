{ lib, stdenv, cmake, ninja, gtest, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "libhwy";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "highway";
    rev = version;
    hash = "sha256-CHjLD2qXmmggJXm15tdp+Nc/vyUIlrg4ZOvI4FA9lkc=";
  };

  nativeBuildInputs = [ cmake ninja ];

  checkInputs = [ gtest ];

  # Required for case-insensitive filesystems ("BUILD" exists)
  dontUseCmakeBuildDir = true;

  cmakeFlags = [
    "-GNinja"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ] ++ lib.optional doCheck "-DHWY_SYSTEM_GTEST:BOOL=ON";

  # hydra's darwin machines run into https://github.com/libjxl/libjxl/issues/408
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = with lib; {
    description = "Performance-portable, length-agnostic SIMD with runtime dispatch";
    homepage = "https://github.com/google/highway";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
