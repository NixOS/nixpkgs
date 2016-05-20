{stdenv, lib, fetchgit, cmake, libconfig, llvm, gcc6}:

stdenv.mkDerivation rec {
  name = "ldc-${version}";
  version = "0.17.1";

  src = fetchgit {
    url = "https://github.com/ldc-developers/ldc.git";
    rev = "refs/tags/v${version}";
    sha256 = "12xbzc9b0hhgda8n0125yn4g545qpazhfpv8hjr26pc8qjg9rlq4";
    fetchSubmodules = true;
  };

  buildInputs = [cmake libconfig llvm];

  enableParallelBuilding = true;
  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_CXX_FLAGS_RELEASE=-std=c++11"
    "-DLLVM_ROOT_DIR=${llvm}"
    "-DCMAKE_C_COMPILER=${gcc6}/bin/cc"
    "-DCMAKE_CXX_COMPILER=${gcc6}/bin/g++"
  ];

  meta = {
    description = "The LLVM-based D compiler";
    hompage = https://wiki.dlang.org/LDC;
    downloadPage = https://github.com/ldc-developers/ldc;
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.bsd3;
  };
}
