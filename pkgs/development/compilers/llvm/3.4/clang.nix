{ stdenv, fetch, cmake, libxml2, libedit, llvm, zlib, version, clang-tools-extra_src }:

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
    cmakeFlags+=(
        "-DCLANG_PATH_TO_LLVM_SOURCE="$(ls -d $PWD/llvm-*)
    )
    (cd llvm-* && patch -Np1 -i ${./llvm-separate-build.patch})
  '';

  patches = [ ./clang-separate-build.patch ./clang-purity.patch ];

  buildInputs = [ cmake libedit libxml2 zlib ];

  cmakeFlags = with stdenv.lib; {
    CMAKE_CXX_FLAGS = "-std=c++11";
    CLANG_PATH_TO_LLVM_BUILD = "${llvm}";
  } // optionalAttrs (stdenv.cc.libc != null) {
    C_INCLUDE_DIRS = "${stdenv.cc.libc}/include";
  } // optionalAttrs (stdenv.cc.cc != null) {
    GCC_INSTALL_PREFIX = "${stdenv.cc.cc}";
  };

  # Clang expects to find LLVMgold in its own prefix
  # Clang expects to find sanitizer libraries in its own prefix
  postInstall = ''
    if [ -e ${llvm}/lib/LLVMgold.so ]; then
      ln -sv ${llvm}/lib/LLVMgold.so $out/lib
    fi

    ln -sv ${llvm}/lib/clang/${version}/lib $out/lib/clang/${version}/
  '';

  passthru = {
    isClang = true;
    cc = stdenv.cc.cc;
    # GCC_INSTALL_PREFIX points here, so just use it even though it may not
    # actually be a gcc
    gcc = stdenv.cc.cc;
    hardeningUnsupportedFlags = [ "stackprotector" ];
  };

  enableParallelBuilding = true;

  meta = {
    description = "A c, c++, objective-c, and objective-c++ frontend for the llvm compiler";
    homepage    = http://llvm.org/;
    license     = stdenv.lib.licenses.ncsa;
    platforms   = stdenv.lib.platforms.all;
  };
}
