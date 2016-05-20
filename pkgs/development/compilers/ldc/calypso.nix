{stdenv, lib, fetchgit, cmake, libconfig, llvm_36, gcc6}:

stdenv.mkDerivation rec {
  name = "ldc-calypso-${version}";
  version = "0.17.1";

  src = fetchgit {
    url = "https://github.com/Syniurge/Calypso.git";
    rev = "af189b9da8520f872fe8c034a8f42e793a06cbb9";
    sha256 = "1y36dvdcikbdxlvn0dy22rdpm0ps6f0vrw3qsw0vh9f318jsv21i";
    fetchSubmodules = true;
  };

  buildInputs = [cmake libconfig llvm_36];

  enableParallelBuilding = true;
  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_CXX_FLAGS_RELEASE=-std=c++11"
    "-DLLVM_ROOT_DIR=${llvm_36}"
    "-DCMAKE_C_COMPILER=${gcc6}/bin/cc"
    "-DCMAKE_CXX_COMPILER=${gcc6}/bin/g++"
  ];

  postInstall = ''
    cp $out/bin/ldc2 $out/bin/ldc2-calypso
  '';

  meta = {
    description = "Fork of LDC to experiment direct interfacing with C++";
    hompage = https://github.com/Syniurge/Calypso;
    priority = 10;
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.bsd3;
  };
}
