{stdenv, lib, fetchgit, cmake, libconfig, llvm, gcc6}:

stdenv.mkDerivation rec {
  name = "ldc-${version}";
  version = "0.17.1";

  src = fetchgit {
    url = "https://github.com/ldc-developers/ldc.git";
    rev = "refs/tags/v${version}";
    sha256 = "1jbvl4iv7r50lxrdiqpdgp5b0kv3igy9sz12cyr3nkjs0fkr54sx";
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
    description = "The LLVM-based D compiler.";
    hompage = https://wiki.dlang.org/LDC;
    downloadPage = https://github.com/ldc-developers/ldc;
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.bsd3;
  };
}
