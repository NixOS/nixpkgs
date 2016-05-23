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
, libcxxabi
, debugVersion ? false
, enableSharedLibraries ? !stdenv.isDarwin
}:

let
  src = fetch "llvm" "0ikfq0gxac8xpvxj23l4hk8f12ydx48fljgrz1gl9xp0ks704nsm";
in stdenv.mkDerivation rec {
  name = "llvm-${version}";

  unpackPhase = ''
    unpackFile ${src}
    mv llvm-${version}.src llvm
    sourceRoot=$PWD/llvm
    unpackFile ${compiler-rt_src}
    mv compiler-rt-* $sourceRoot/projects/compiler-rt
  '';

  buildInputs = [ perl groff cmake libxml2 python libffi ]
    ++ stdenv.lib.optional stdenv.isDarwin libcxxabi;

  propagatedBuildInputs = [ ncurses zlib ];

  # hacky fix: New LLVM releases require a newer OS X SDK than
  # 10.9. This is a temporary measure until nixpkgs darwin support is
  # updated.
  patchPhase = stdenv.lib.optionalString stdenv.isDarwin ''
        sed -i 's/os_trace(\(.*\)");$/printf(\1\\n");/g' ./projects/compiler-rt/lib/sanitizer_common/sanitizer_mac.cc
  '';

  # hacky fix: created binaries need to be run before installation
  preBuild = ''
    mkdir -p $out/
    ln -sv $PWD/lib $out
  '';

  cmakeFlags = with stdenv; [
    "-DCMAKE_BUILD_TYPE=${if debugVersion then "Debug" else "Release"}"
    "-DLLVM_INSTALL_UTILS=ON"  # Needed by rustc
    "-DLLVM_BUILD_TESTS=ON"
    "-DLLVM_ENABLE_FFI=ON"
    "-DLLVM_ENABLE_RTTI=ON"
  ] ++ stdenv.lib.optional enableSharedLibraries [
    "-DLLVM_LINK_LLVM_DYLIB=ON"
  ] ++ stdenv.lib.optional (!isDarwin)
    "-DLLVM_BINUTILS_INCDIR=${binutils.dev}/include"
    ++ stdenv.lib.optionals ( isDarwin) [
    "-DLLVM_ENABLE_LIBCXX=ON"
    "-DCAN_TARGET_i386=false"
  ];

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
