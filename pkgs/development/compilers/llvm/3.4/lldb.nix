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
, python2
, version
}:

stdenv.mkDerivation {
  name = "lldb-${version}";

  src = fetch "lldb" "0h8cmjrhjhigk7k2qll1pcf6jfgmbdzkzfz2i048pkfg851s0x4g";

  patchPhase = ''
    sed -i 's|/usr/bin/env||' \
      scripts/Python/finish-swig-Python-LLDB.sh \
      scripts/Python/build-swig-Python.sh
  '';

  buildInputs = [ cmake python2 which swig ncurses zlib libedit ];

  cmakeFlags = {
    CMAKE_CXX_FLAGS = "-std=c++11";
    LLDB_PATH_TO_LLVM_BUILD = "${llvm}";
    LLDB_PATH_TO_CLANG_BUILD = "${clang}";
    LLDB_DISABLE_LIBEDIT = true; # https://llvm.org/bugs/show_bug.cgi?id=28898
  };

  enableParallelBuilding = true;

  meta = {
    description = "A next-generation high-performance debugger";
    homepage    = http://llvm.org/;
    license     = stdenv.lib.licenses.ncsa;
    platforms   = stdenv.lib.platforms.all;
  };
}
