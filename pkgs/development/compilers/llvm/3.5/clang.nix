{ stdenv, fetch, cmake, libxml2, libedit, llvm, version, clang-tools-extra_src }:

stdenv.mkDerivation {
  name = "clang-${version}";

  unpackPhase = ''
    unpackFile ${fetch "cfe" "12yv3jwdjcbkrx7zjm8wh4jrvb59v8fdw4mnmz3zc1jb00p9k07w"}
    mv cfe-${version}.src clang
    sourceRoot=$PWD/clang
    unpackFile ${clang-tools-extra_src}
    mv clang-tools-extra-* $sourceRoot/tools/extra
  '';

  buildInputs = [ cmake libedit libxml2 llvm ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_CXX_FLAGS=-std=c++11"
  ] ++
  (stdenv.lib.optional (stdenv.cc.libc != null) "-DC_INCLUDE_DIRS=${stdenv.cc.libc}/include");

  patches = [ ./clang-purity.patch ];

  # Clang expects to find LLVMgold in its own prefix
  # Clang expects to find sanitizer libraries in its own prefix
  postInstall = ''
    ln -sv ${llvm}/lib/LLVMgold.so $out/lib
    ln -sv ${llvm}/lib/clang/${version}/lib $out/lib/clang/${version}/
    ln -sv $out/bin/clang $out/bin/cpp
  '';

  enableParallelBuilding = true;

  meta = {
    description = "A c, c++, objective-c, and objective-c++ frontend for the llvm compiler";
    homepage    = http://llvm.org/;
    license     = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.shlevy ];
    platforms   = stdenv.lib.platforms.all;
  };
}
