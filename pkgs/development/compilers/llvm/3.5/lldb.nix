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

  src = fetch "lldb" "0ffi9jn4k3yd0hvxs1v4n710x8siq21lb49v3351d7j5qinrpgi7";

  patchPhase = ''
    sed -i 's|/usr/bin/env||' \
      scripts/Python/finish-swig-Python-LLDB.sh \
      scripts/Python/build-swig-Python.sh
  '';

  buildInputs = [ cmake python which swig ncurses zlib libedit ];

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
    broken = true;
  };
}
