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

  src = fetch "openmp" "1lgsn70rsmmc52qynd2r05bq34cllzyxb40vsqqv2vl3kicjis5k";

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
