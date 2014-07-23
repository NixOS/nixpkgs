{ stdenv
, fetch
, cmake
, zlib
, ncurses
, swig
, which
, libedit
, llvm
, clang
, python
, version
}:

stdenv.mkDerivation {
  name = "lldb-${version}";

  src = fetch "lldb" "8f74a04341cfcd8b0888e2bb3f7f5bf539691cbb81522ce6992f4209b3ac0c41";

  patchPhase = ''
    sed -i 's|/usr/bin/env||' \
      scripts/Python/finish-swig-Python-LLDB.sh \
      scripts/Python/build-swig-Python.sh
  '';

  buildInputs = [ cmake python which swig ncurses zlib libedit ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_CXX_FLAGS=-std=c++11"
    "-DLLDB_PATH_TO_LLVM_BUILD=${llvm}"
    "-DLLDB_PATH_TO_CLANG_BUILD=${clang}"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "A next-generation high-performance debugger";
    homepage    = http://llvm.org/;
    license     = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.shlevy ];
    platforms   = stdenv.lib.platforms.all;
  };
}
