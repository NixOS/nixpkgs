{ stdenv
, fetch
, perl
, groff
, cmake
, python
, libffi
, binutils
, libxml2
, valgrind
, ncurses
, version
, zlib
}:

let
  src = fetch "llvm" "0a169ba045r4apb9cv6ncrwl83l7yiajnzirkcdlhj1cd4nn3995";
in stdenv.mkDerivation rec {
  name = "llvm-${version}";

  unpackPhase = ''
    unpackFile ${src}
    mv llvm-${version} llvm
    sourceRoot=$PWD/llvm
    unpackFile ${fetch "compiler-rt" "0p5b6varxdqn7q3n77xym63hhq4qqxd2981pfpa65r1w72qqjz7k"}
    mv compiler-rt-${version} $sourceRoot/projects/compiler-rt
  '';

  buildInputs = [ perl groff cmake libxml2 python libffi ] ++ stdenv.lib.optional stdenv.isLinux valgrind;

  propagatedBuildInputs = [ ncurses zlib ];

  # hacky fix: created binaries need to be run before installation
  preBuild = ''
    mkdir -p $out/
    ln -sv $PWD/lib $out
  '';
  postBuild = "rm -fR $out";

  cmakeFlags = with stdenv; [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DLLVM_ENABLE_FFI=ON"
    "-DLLVM_BINUTILS_INCDIR=${binutils}/include"
    "-DCMAKE_CXX_FLAGS=-std=c++11"
  ] ++ stdenv.lib.optional (!isDarwin) "-DBUILD_SHARED_LIBS=ON";

  enableParallelBuilding = true;

  passthru.src = src;

  meta = {
    description = "Collection of modular and reusable compiler and toolchain technologies";
    homepage    = http://llvm.org/;
    license     = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ shlevy lovek323 raskin viric ];
    platforms   = stdenv.lib.platforms.all;
  };
}
