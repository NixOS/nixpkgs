{ stdenv
, fetch
, fetchpatch
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
, release_version
, zlib
, compiler-rt_src
, libcxxabi
, debugVersion ? false
, enableSharedLibraries ? true
, darwin
}:

let
  src = fetch "llvm" "1qfvvblca2aa5shamz66132k30hmpq2mkpfn172xzzlm6znzlmr2";
  shlib = if stdenv.isDarwin then "dylib" else "so";

  # Used when creating a version-suffixed symlink of libLLVM.dylib
  shortVersion = with stdenv.lib;
    concatStringsSep "." (take 2 (splitString "." release_version));
in stdenv.mkDerivation rec {
  name = "llvm-${version}";

  unpackPhase = ''
    unpackFile ${src}
    mv llvm-${version}* llvm
    sourceRoot=$PWD/llvm
    unpackFile ${compiler-rt_src}
    mv compiler-rt-* $sourceRoot/projects/compiler-rt
  '';

  outputs = [ "out" ] ++ stdenv.lib.optional enableSharedLibraries "lib";

  buildInputs = [ perl groff cmake libxml2 python libffi ]
    ++ stdenv.lib.optionals stdenv.isDarwin
         [ libcxxabi darwin.cctools darwin.apple_sdk.libs.xpc ];

  propagatedBuildInputs = [ ncurses zlib ];

  # hacky fix: New LLVM releases require a newer OS X SDK than
  # 10.9. This is a temporary measure until nixpkgs darwin support is
  # updated.
  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
        sed -i 's/os_trace(\(.*\)");$/printf(\1\\n");/g' ./projects/compiler-rt/lib/sanitizer_common/sanitizer_mac.cc
  ''
  # Patch llvm-config to return correct library path based on --link-{shared,static}.
  + stdenv.lib.optionalString (enableSharedLibraries) ''
    substitute '${./llvm-outputs.patch}' ./llvm-outputs.patch --subst-var lib
    patch -p1 < ./llvm-outputs.patch
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
    "-DCOMPILER_RT_INCLUDE_TESTS=OFF" # FIXME: requires clang source code
  ] ++ stdenv.lib.optional enableSharedLibraries [
    "-DLLVM_LINK_LLVM_DYLIB=ON"
  ] ++ stdenv.lib.optional (!isDarwin)
    "-DLLVM_BINUTILS_INCDIR=${binutils.dev}/include"
    ++ stdenv.lib.optionals (isDarwin) [
    "-DLLVM_ENABLE_LIBCXX=ON"
    "-DCAN_TARGET_i386=false"
    "-DCMAKE_LIBTOOL=${darwin.cctools}/bin/libtool"
  ];

  postBuild = ''
    rm -fR $out

    paxmark m bin/{lli,llvm-rtdyld}
  '';

  postInstall = ""
  + stdenv.lib.optionalString (enableSharedLibraries) ''
    moveToOutput "lib/libLLVM-*" "$lib"
    moveToOutput "lib/libLLVM.${shlib}" "$lib"
    substituteInPlace "$out/lib/cmake/llvm/LLVMExports-release.cmake" \
      --replace "\''${_IMPORT_PREFIX}/lib/libLLVM-" "$lib/lib/libLLVM-"
  ''
  + stdenv.lib.optionalString (stdenv.isDarwin && enableSharedLibraries) ''
    substituteInPlace "$out/lib/cmake/llvm/LLVMExports-release.cmake" \
      --replace "\''${_IMPORT_PREFIX}/lib/libLLVM.dylib" "$lib/lib/libLLVM.dylib"
    install_name_tool -id $lib/lib/libLLVM.dylib $lib/lib/libLLVM.dylib
    install_name_tool -change @rpath/libLLVM.dylib $lib/lib/libLLVM.dylib $out/bin/llvm-config
    ln -s $lib/lib/libLLVM.dylib $lib/lib/libLLVM-${shortVersion}.dylib
    ln -s $lib/lib/libLLVM.dylib $lib/lib/libLLVM-${release_version}.dylib
  '';

  enableParallelBuilding = true;

  passthru.src = src;

  meta = {
    description = "Collection of modular and reusable compiler and toolchain technologies";
    homepage    = http://llvm.org/;
    license     = stdenv.lib.licenses.ncsa;
    maintainers = with stdenv.lib.maintainers; [ lovek323 raskin viric ];
    platforms   = stdenv.lib.platforms.all;
  };
}
