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

  src = fetch "lldb" "1113s6crh94hzk9h9lqrvng0lsy174ml2rq0r962ngqy843hwa31";

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
    "-DCMAKE_BUILD_TYPE=Release"
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
