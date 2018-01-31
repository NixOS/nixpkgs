{ stdenv
, fetch
, cmake
, zlib
, llvm
, perl
, version
}:

stdenv.mkDerivation {
  name = "openmp-${version}";

  src = fetch "openmp" "0infci57hr89nxgs3v34z87kaqdw9pdkr6apyywkb8av032rhhpf";

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
