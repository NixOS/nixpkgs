{ stdenv
, fetch
, cmake
, llvm
, perl
, version
}:

stdenv.mkDerivation {
  name = "openmp-${version}";

  src = fetch "openmp" "1ab4m3agbk9zx810bbvxbjg3103y337zff0ngajk77nvsmc6fl55";

  nativeBuildInputs = [ cmake perl ];
  buildInputs = [ llvm ];

  enableParallelBuilding = true;

  meta = {
    description = "Components required to build an executable OpenMP program";
    homepage    = http://openmp.llvm.org/;
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.all;
  };
}
