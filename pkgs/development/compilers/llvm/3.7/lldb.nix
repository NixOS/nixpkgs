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

  src = fetch "lldb" "1sbi9c6c4m73wfw249dn0n2974p444i03brk82m4w10iq5dm1mzl";

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
