{ stdenv, fetch, cmake, libxml2, libedit, llvm, version, clang-tools-extra_src }:

stdenv.mkDerivation {
  name = "clang-${version}";

  unpackPhase = ''
    unpackFile ${fetch "cfe" "045wjnp5j8xd2zjhvldcllnwlnrwz3dafmlk412z804d5xvzb9jv"}
    mv cfe-${version}.src clang
    sourceRoot=$PWD/clang
    unpackFile ${clang-tools-extra_src}
    mv clang-tools-extra-* $sourceRoot/tools/extra
    # !!! Hopefully won't be needed for 3.5
    unpackFile ${llvm.src}
    export cmakeFlags="$cmakeFlags -DCLANG_PATH_TO_LLVM_SOURCE="`ls -d $PWD/llvm-*`
    (cd llvm-* && patch -Np1 -i ${./llvm-separate-build.patch})
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
  # Clang expects to find sanitizer libraries in its own prefix
  postInstall = ''
    ln -sv ${llvm}/lib/LLVMgold.so $out/lib
    ln -sv ${llvm}/lib/clang/${version}/lib $out/lib/clang/${version}/
  '';

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
