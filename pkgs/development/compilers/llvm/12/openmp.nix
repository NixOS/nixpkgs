{ lib
, stdenv
, fetch
, cmake
, llvm
, perl
, version
}:

stdenv.mkDerivation rec {
  pname = "openmp";
  inherit version;

  src = fetch pname "0z8n1wanby6aq3i7d91mgk72hb33zfl5blayk0a22cs7l8i706zb";

  nativeBuildInputs = [ cmake perl ];
  buildInputs = [ llvm ];

  meta = {
    description = "Components required to build an executable OpenMP program";
    homepage    = "https://openmp.llvm.org/";
    license     = lib.licenses.mit;
    platforms   = lib.platforms.all;
  };
}
