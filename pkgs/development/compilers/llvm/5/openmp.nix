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

  src = fetch "openmp" "0lr6r87xzg87w1q9rrh04nqpyr8c929dh4qy3csjiy7rsb6kbdmd";

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
