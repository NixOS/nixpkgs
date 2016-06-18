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

  src = fetch "lldb" "0dasg12gf5crrd9pbi5rd1y8vwlgqp8nxgw9g4z47w3x2i28zxp3";

  postUnpack = ''
    # Hack around broken standalone builf as of 3.8
    unpackFile ${llvm.src}
    srcDir="$(ls -d lldb-*.src)"
    mkdir -p "$srcDir/tools/lib/Support"
    cp "$(ls -d llvm-*.src)/lib/Support/regex_impl.h" "$srcDir/tools/lib/Support/"
  '';

  buildInputs = [ cmake python which swig ncurses zlib libedit ];

  preConfigure = ''
    export CXXFLAGS="-pthread"
    export LDFLAGS="-ldl"
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DLLDB_PATH_TO_LLVM_BUILD=${llvm}"
    "-DLLVM_MAIN_INCLUDE_DIR=${llvm}/include"
    "-DLLDB_PATH_TO_CLANG_BUILD=${clang-unwrapped}"
    "-DCLANG_MAIN_INCLUDE_DIR=${clang-unwrapped}/include"
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
