{ stdenv, fetch, cmake, llvm, ncurses, zlib, python, version }:

stdenv.mkDerivation {
  name = "lld-${version}";

  src = fetch "lld" "bf5bd1ae551250a33c281f0d57d7aaf23561f9931440c258cdce67eb31d3a4e9";

  preUnpack = ''
    # !!! Hopefully won't be needed for 3.5
    unpackFile ${llvm.src}
    export cmakeFlags="$cmakeFlags -DLLD_PATH_TO_LLVM_SOURCE="`ls -d $PWD/llvm-*`
  '';

  buildInputs = [ cmake ncurses zlib python ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_CXX_FLAGS=-std=c++11"
    "-DLLD_PATH_TO_LLVM_BUILD=${llvm}"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "A set of modular code for creating linker tools";
    homepage    = http://llvm.org/;
    license     = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.shlevy ];
    platforms   = stdenv.lib.platforms.all;
  };
}
