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

  src = fetch "lldb" "1z30ljmcpp261bjng1i5k3bb9jkrs1cr97z04qs4s3zql6r12cvy";

  postUnpack = ''
    # Hack around broken standalone build as of 3.8
    unpackFile ${llvm.src}
    srcDir="$(ls -d lldb-*.src)"
    mkdir -p "$srcDir/tools/lib/Support"
    cp "$(ls -d llvm-*.src)/lib/Support/regex_impl.h" "$srcDir/tools/lib/Support/"

    # Fix up various paths that assume llvm and clang are installed in the same place
    substituteInPlace $srcDir/cmake/modules/LLDBStandalone.cmake \
      --replace CheckAtomic $(readlink -f llvm-*.src)/cmake/modules/CheckAtomic.cmake
    sed -i 's,".*ClangConfig.cmake","${clang-unwrapped}/lib/cmake/clang/ClangConfig.cmake",' \
      $srcDir/cmake/modules/LLDBStandalone.cmake
    sed -i 's,".*tools/clang/include","${clang-unwrapped}/include",' \
      $srcDir/cmake/modules/LLDBStandalone.cmake
    sed -i 's,"$.LLVM_LIBRARY_DIR.",${llvm}/lib ${clang-unwrapped}/lib,' \
      $srcDir/cmake/modules/LLDBStandalone.cmake
  '';

  buildInputs = [ cmake python which swig ncurses zlib libedit llvm ];

  CXXFLAGS = "-fno-rtti";
  hardeningDisable = [ "format" ];

  cmakeFlags = [
    "-DLLVM_MAIN_INCLUDE_DIR=${llvm}/include"
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
