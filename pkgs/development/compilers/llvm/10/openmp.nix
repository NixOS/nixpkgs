{ stdenv
, fetch
, cmake
, llvm
, perl
, version
}:

stdenv.mkDerivation rec {
  pname = "openmp";
  inherit version;

  src = fetch pname "0i4bn84lkpm5w3qkpvwm5z6jdj8fynp7d3bcasa1xyq4is6757yi";

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
