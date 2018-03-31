{ stdenv
, fetch
, fetchpatch
, perl
, groff
, cmake
, python2
, libffi
, libbfd
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
    [ perl groff cmake libxml2 libffi python2 ] /*
    ++ stdenv.lib.optional stdenv.isLinux valgrind */;

  propagatedBuildInputs = [ ncurses zlib ];

  patches = stdenv.lib.optionals (!stdenv.isDarwin) [
    # llvm-config --libfiles returns (non-existing) static libs
    ../fix-llvm-config.patch
  ];

  postPatch = stdenv.lib.optionalString (stdenv ? glibc) ''
    (
     cd projects/compiler-rt
      patch -p1 -F3 < ${
        fetchpatch {
          name = "sigaltstack.patch"; # for glibc-2.26
          url = https://github.com/llvm-mirror/compiler-rt/commit/8a5e425a68d.diff;
          sha256 = "0h4y5vl74qaa7dl54b1fcyqalvlpd8zban2d1jxfkxpzyi7m8ifi";
        }
      }

      sed -i "s,#include <pthread.h>,&\n#include <signal.h>,g" \
        lib/asan/asan_linux.cc
    )
  '';

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
    "-DLLVM_BINUTILS_INCDIR=${libbfd.dev}/include"
    "-DCMAKE_CXX_FLAGS=-std=c++11"
  ] ++ stdenv.lib.optional (!stdenv.isDarwin) "-DBUILD_SHARED_LIBS=ON";

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
    license     = stdenv.lib.licenses.ncsa;
    maintainers = with stdenv.lib.maintainers; [ lovek323 raskin viric ];
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin"];
  };
}
