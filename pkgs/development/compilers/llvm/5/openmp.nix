{ stdenv
, fetch
, cmake
, llvm
, perl
, version
}:

stdenv.mkDerivation {
  pname = "openmp";
  inherit version;

  src = fetch "openmp" "0p2n52676wlq6y9q99n5pivq6pvvda1p994r69fxj206ahn59jir";

  nativeBuildInputs = [ cmake perl ];
  buildInputs = [ llvm ];

  enableParallelBuilding = true;

  meta = {
    description = "Components required to build an executable OpenMP program";
    homepage    = "https://openmp.llvm.org/";
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.all;
  };
}
