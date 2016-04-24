{ stdenv
, fetch
, cmake
, zlib
, ncurses
, swig
, which
, libedit
, llvm
, clang-unwrapped
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

  preConfigure = ''
    export CXXFLAGS="-pthread"
    export LDFLAGS="-ldl"
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DLLDB_PATH_TO_LLVM_BUILD=${llvm}"
    "-DLLDB_PATH_TO_CLANG_BUILD=${clang-unwrapped}"
    "-DPYTHON_VERSION_MAJOR=2"
    "-DPYTHON_VERSION_MINOR=7"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "A next-generation high-performance debugger";
    homepage    = http://llvm.org/;
    license     = stdenv.lib.licenses.bsd3;
    platforms   = stdenv.lib.platforms.all;
  };
}

