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
, compiler-rt_src
, debugVersion ? false
}:

let
  src = fetch "llvm" "1mzgy7r0dma0npi1qrbr1s5n4nbj1ipxgbiw0q671l4s0r3qs0qp";
in stdenv.mkDerivation rec {
  name = "llvm-${version}";

  unpackPhase = ''
    unpackFile ${src}
    mv llvm-${version}.src llvm
    sourceRoot=$PWD/llvm
    unpackFile ${compiler-rt_src}
    mv compiler-rt-* $sourceRoot/projects/compiler-rt
  '';

  buildInputs =
    [ perl groff cmake libxml2 libffi ]
    ++ stdenv.lib.optional (!stdenv.isDarwin) python /*
    ++ stdenv.lib.optional stdenv.isLinux valgrind */;

  propagatedBuildInputs = [ ncurses zlib ];

  # hacky fix: created binaries need to be run before installation
  preBuild = ''
    mkdir -p $out/
    ln -sv $PWD/lib $out
  '';

  cmakeFlags = with stdenv; [
    "-DCMAKE_BUILD_TYPE=${if debugVersion then "Debug" else "Release"}"
    "-DLLVM_BUILD_TESTS=ON"
    "-DLLVM_ENABLE_FFI=ON"
    "-DLLVM_REQUIRES_RTTI=1"
    "-DLLVM_BINUTILS_INCDIR=${binutils.dev}/include"
    "-DCMAKE_CXX_FLAGS=-std=c++11"
  ] ++ stdenv.lib.optional (!isDarwin) "-DBUILD_SHARED_LIBS=ON";

  postBuild = ''
    rm -fR $out

    paxmark m bin/{lli,llvm-rtdyld}

    paxmark m unittests/ExecutionEngine/JIT/JITTests
    paxmark m unittests/ExecutionEngine/MCJIT/MCJITTests
    paxmark m unittests/Support/SupportTests
  '';

  enableParallelBuilding = true;

  passthru.src = src;

  meta = {
    description = "Collection of modular and reusable compiler and toolchain technologies";
    homepage    = http://llvm.org/;
    license     = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ lovek323 raskin viric ];
    platforms   = stdenv.lib.platforms.all;
  };
}
