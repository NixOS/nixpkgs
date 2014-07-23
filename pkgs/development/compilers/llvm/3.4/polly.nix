{ stdenv, fetch, cmake, isl, python, gmp, llvm, version }:

stdenv.mkDerivation {
  name = "polly-${version}";

  src =  fetch "polly" "9f1a5fb73dddc0afe47a0f4108dea818e0d1d16485899141957f87f75fa50ee7";

  patches = [ ./polly-separate-build.patch ];

  buildInputs = [ cmake isl python gmp ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_CXX_FLAGS=-std=c++11"
    "-DLLVM_INSTALL_ROOT=${llvm}"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "A polyhedral optimizer for llvm";
    homepage    = http://llvm.org/;
    license     = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.shlevy ];
    platforms   = stdenv.lib.platforms.all;
  };
}
