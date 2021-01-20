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

  src = fetch pname "19rcv25y41ww3zlfg0lwprzijl3cn7jgc0v5540jzpp7j0ds45ad";

  nativeBuildInputs = [ cmake perl ];
  buildInputs = [ llvm ];

  meta = {
    description = "Components required to build an executable OpenMP program";
    homepage    = "https://openmp.llvm.org/";
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.all;
  };
}
