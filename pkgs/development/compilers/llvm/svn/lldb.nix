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

  src = fetch "lldb" "0wh6bynr8vmzq5rc029saca4pfbzp1i8rxfr7qnmq9lsd7fdkmyr";

  postUnpack = ''
    # Hack around broken standalone build as of 3.8
    unpackFile ${llvm.src}
    chmod -R u+w llvm-*
    srcDir="$(ls -d lldb-*)"
    mkdir -p "$srcDir/tools/lib/Support"
    cp "$(ls -d llvm-*)/lib/Support/regex_impl.h" "$srcDir/tools/lib/Support/"

    # Fix up various paths that assume llvm and clang are installed in the same place
    substituteInPlace $srcDir/cmake/modules/LLDBStandalone.cmake \
      --replace CheckAtomic $(readlink -f llvm-*)/cmake/modules/CheckAtomic.cmake
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
  ];

  enableParallelBuilding = true;

  meta = {
    description = "A next-generation high-performance debugger";
    homepage    = http://llvm.org/;
    license     = stdenv.lib.licenses.bsd3;
    platforms   = stdenv.lib.platforms.all;
  };
}
