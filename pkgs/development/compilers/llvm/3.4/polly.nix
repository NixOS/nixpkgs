{ stdenv, fetch, cmake, isl, python2, gmp, llvm, version }:

stdenv.mkDerivation {
  name = "polly-${version}";

  src =  fetch "polly" "1rqflmgzg1vzjm0r32c5ck8x3q0qm3g0hh8ggbjazh6x7nvmy6lz";

  patches = [ ./polly-separate-build.patch ];

  buildInputs = [ cmake isl python2 gmp ];

  cmakeFlags = [
    "-DCMAKE_CXX_FLAGS=-std=c++11"
    "-DLLVM_INSTALL_ROOT=${llvm}"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "A polyhedral optimizer for llvm";
    homepage    = http://llvm.org/;
    license     = stdenv.lib.licenses.ncsa;
    platforms   = stdenv.lib.platforms.all;
  };
}
