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
, enableSharedLibraries ? !stdenv.isDarwin
}:

let
  src = fetch "llvm" "555b028e9ee0f6445ff8f949ea10e9cd8be0d084840e21fbbe1d31d51fc06e46";
in stdenv.mkDerivation rec
{
  name = "llvm-${version}";

  unpackPhase = ''
    unpackFile ${src}
    mv llvm-${version}.src llvm
    sourceRoot=$PWD/llvm
    unpackFile ${compiler-rt_src}
    mv compiler-rt-* $sourceRoot/projects/compiler-rt
  '';

  buildInputs = [ perl groff cmake libxml2 python libffi ];

  propagatedBuildInputs = [ ncurses zlib ];

  # hacky fix: created binaries need to be run before installation
  preBuild = ''
    mkdir -p $out/
    ln -sv $PWD/lib $out
  '';

  cmakeFlags = with stdenv;
  [
    "-DCMAKE_BUILD_TYPE=${if debugVersion then "Debug" else "Release"}"
    "-DLLVM_INSTALL_UTILS=ON"  # Needed by rustc
    "-DLLVM_BUILD_TESTS=ON"
    "-DLLVM_ENABLE_FFI=ON"
    "-DLLVM_ENABLE_RTTI=ON"
  ] ++ stdenv.lib.optional enableSharedLibraries
  [
      "-DBUILD_SHARED_LIBS=OFF" # make libLLVM.so have no dynamic dependencies
      "-DLLVM_BUILD_LLVM_DYLIB=ON"
      "-DLLVM_DYLIB_EXPORT_ALL=ON"
  ]
    ++ stdenv.lib.optional (!isDarwin)
    "-DLLVM_BINUTILS_INCDIR=${binutils}/include"
    ++ stdenv.lib.optionals (isDarwin)
  [
    "-DCMAKE_CXX_FLAGS=-stdlib=libc++"
    "-DCAN_TARGET_i386=false"
  ];

  # NIX_LDFLAGS = "-lpthread";

  postBuild = ''
    rm -rf $outs
    paxmark m bin/{lli, llvm-rtdyld}

    paxmark m unittests/ExecutionEngine/JIT/JITTests
    paxmark m unittests/ExecutionEngine/MCJIT/MCJITTests
    paxmark m unittests/Support/SupportTests
  '';

  enableParallelBuilding = true;

  passthru.src = src;

  meta =
  {
    description = "Collection of modular and reusable compiler and toolchain technologies";
    homepage    = http://llvm.org/;
    license     = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ lovek323 raskin viric ];
    platforms   = stdenv.lib.platforms.all;
  };
}
