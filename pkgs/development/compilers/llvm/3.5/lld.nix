{ stdenv, fetch, cmake, llvm, ncurses, zlib, python, version }:

stdenv.mkDerivation {
  name = "lld-${version}";

  src = fetch "lld" "1hpqawg1sc8mdqxqaxqmlzbrn69w1pkj8rxhjgqgmwra6c0xky89";

  preUnpack = ''
    # !!! Hopefully won't be needed for 3.5
    unpackFile ${llvm.src}
    export cmakeFlags="$cmakeFlags -DLLD_PATH_TO_LLVM_SOURCE="`ls -d $PWD/llvm-*`
  '';

  buildInputs = [ cmake ncurses zlib python ];

  cmakeFlags = [
    "-DCMAKE_CXX_FLAGS=-std=c++11"
    "-DLLD_PATH_TO_LLVM_BUILD=${llvm}"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "A set of modular code for creating linker tools";
    homepage    = http://llvm.org/;
    license     = stdenv.lib.licenses.bsd3;
    platforms   = stdenv.lib.platforms.all;
  };
}
