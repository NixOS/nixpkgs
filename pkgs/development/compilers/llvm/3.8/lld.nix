{ stdenv, fetch, cmake, llvm, ncurses, zlib, python, version }:

stdenv.mkDerivation {
  name = "lld-${version}";

  src = fetch "lld" "94704dda228c9f75f4403051085001440b458501ec97192eee06e8e67f7f9f0c";

  preUnpack = ''
    unpackFile ${llvm.src}
    export cmakeFlags="$cmakeFlags -DLLD_PATH_TO_LLVM_SOURCE="`ls -d $PWD/llvm-*`
  '';

  buildInputs = [ cmake ncurses zlib python ];

  cmakeFlags = [
    "-DLLD_VERSION=${version}"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_CXX_FLAGS=-std=c++11"
    "-DLLD_PATH_TO_LLVM_BUILD=${llvm}"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "A set of modular code for creating linker tools";
    homepage    = http://llvm.org/;
    license     = stdenv.lib.licenses.bsd3;
    platforms   = stdenv.lib.platforms.all;
    broken      = true;
  };
}
