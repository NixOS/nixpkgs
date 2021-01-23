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

  src = fetch pname "0k59rlyc5kxp58lbx8rqrj1xfcwjqgaq68hn8agavvqgqgxfp2v2";

  nativeBuildInputs = [ cmake perl ];
  buildInputs = [ llvm ];

  meta = {
    description = "Components required to build an executable OpenMP program";
    homepage    = "https://openmp.llvm.org/";
    license     = lib.licenses.mit;
    platforms   = lib.platforms.all;
  };
}
