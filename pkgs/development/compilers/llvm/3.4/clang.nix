{ stdenv, fetch, cmake, libxml2, libedit, llvm, version }:

stdenv.mkDerivation {
  name = "clang-${version}";

  unpackPhase = ''
    unpackFile ${fetch "clang" "06rb4j1ifbznl3gfhl98s7ilj0ns01p7y7zap4p7ynmqnc6pia92"}
    mv clang-${version} clang
    sourceRoot=$PWD/clang
    unpackFile ${fetch "clang-tools-extra" "1d1822mwxxl9agmyacqjw800kzz5x8xr0sdmi8fgx5xfa5sii1ds"}
    mv clang-tools-extra-${version} $sourceRoot/tools/extra
    # !!! Hopefully won't be needed for 3.5
    unpackFile ${llvm.src}
    export cmakeFlags="$cmakeFlags -DCLANG_PATH_TO_LLVM_SOURCE=$PWD/llvm-${version}"
    (cd llvm-${version} && patch -Np1 -i ${./llvm-separate-build.patch})
  '';

  patches = [ ./clang-separate-build.patch ./clang-purity.patch ];

  buildInputs = [ cmake libedit libxml2 ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_CXX_FLAGS=-std=c++11"
    "-DCLANG_PATH_TO_LLVM_BUILD=${llvm}"
  ] ++
  (stdenv.lib.optional (stdenv.gcc.libc != null) "-DC_INCLUDE_DIRS=${stdenv.gcc.libc}/include") ++
  (stdenv.lib.optional (stdenv.gcc.gcc != null) "-DGCC_INSTALL_PREFIX=${stdenv.gcc.gcc}");

  # Clang expects to find LLVMgold in its own prefix
  postInstall = "ln -sv ${llvm}/lib/LLVMgold.so $out/lib";

  passthru.gcc = stdenv.gcc.gcc;

  enableParallelBuilding = true;

  meta = {
    description = "A c, c++, objective-c, and objective-c++ frontend for the llvm compiler";
    homepage    = http://llvm.org/;
    license     = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.shlevy ];
    platforms   = stdenv.lib.platforms.all;
  };
}
