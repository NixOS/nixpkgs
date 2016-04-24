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

  src = fetch "lldb" "e3f68f44147df0433e7989bf6ed1c58ff28d7c68b9c47553cb9915f744785a35";

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
    platforms   = stdenv.lib.platforms.all;
    broken = true;
  };
}
