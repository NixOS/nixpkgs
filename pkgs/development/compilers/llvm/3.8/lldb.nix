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
  pname = "lldb";
  inherit version;

  src = fetch "lldb" "18z8vhfgh4m57hl66i83cp4d4mv3i86z2hjhbp5rvqs7d88li49l";

  postUnpack = ''
    # Hack around broken standalone builf as of 3.8
    unpackFile ${llvm.src}
    srcDir="$(ls -d lldb-*.src)"
    mkdir -p "$srcDir/tools/lib/Support"
    cp "$(ls -d llvm-*.src)/lib/Support/regex_impl.h" "$srcDir/tools/lib/Support/"
  '';

  buildInputs = [ cmake python which swig ncurses zlib libedit llvm ];

  hardeningDisable = [ "format" ];

  cmakeFlags = [
    "-DLLDB_PATH_TO_LLVM_BUILD=${llvm}"
    "-DLLVM_MAIN_INCLUDE_DIR=${llvm}/include"
    "-DLLDB_PATH_TO_CLANG_BUILD=${clang-unwrapped}"
    "-DCLANG_MAIN_INCLUDE_DIR=${clang-unwrapped}/include"
    "-DPYTHON_VERSION_MAJOR=2"
    "-DPYTHON_VERSION_MINOR=7"
    "-DLLDB_DISABLE_LIBEDIT=1" # https://llvm.org/bugs/show_bug.cgi?id=28898
  ];

  enableParallelBuilding = true;

  meta = {
    description = "A next-generation high-performance debugger";
    homepage    = http://llvm.org/;
    license     = stdenv.lib.licenses.ncsa;
    platforms   = stdenv.lib.platforms.all;
  };
}
