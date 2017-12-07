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
, zlib
, compiler-rt_src
, libcxxabi
, debugVersion ? false
, enableSharedLibraries ? (buildPlatform == hostPlatform)
, darwin
, buildPackages
, buildPlatform
, hostPlatform
}:

assert (hostPlatform != buildPlatform) -> !enableSharedLibraries;

let
  src = fetch "llvm" "1vi9sf7rx1q04wj479rsvxayb6z740iaz3qniwp266fgp5a07n8z";
  shlib = if stdenv.isDarwin then "dylib" else "so";

  # Used when creating a version-suffixed symlink of libLLVM.dylib
  shortVersion = with stdenv.lib;
    concatStringsSep "." (take 2 (splitString "." version));
in stdenv.mkDerivation rec {
  name = "llvm-${version}";

  unpackPhase = ''
    unpackFile ${src}
    mv llvm-${version}.src llvm
    sourceRoot=$PWD/llvm
    unpackFile ${compiler-rt_src}
    mv compiler-rt-* $sourceRoot/projects/compiler-rt
  '';

  outputs = [ "out" ] ++ stdenv.lib.optional enableSharedLibraries "lib";

  nativeBuildInputs = [
    perl
    cmake
    python
  ];

  buildInputs = [
    groff
    libxml2
    libffi
  ] ++ stdenv.lib.optionals stdenv.isDarwin [ libcxxabi ];

  propagatedBuildInputs = [ ncurses zlib ];

  patches = [
    # fix output of llvm-config (fixed in llvm 4.0)
    (fetchpatch {
      url = https://github.com/llvm-mirror/llvm/commit/5340b5b3d970069aebf3dde49d8964583742e01a.patch;
      sha256 = "095f8knplwqbc2p7rad1kq8633i34qynni9jna93an7kyc80wdxl";
   })
  ];

  postPatch = ""
  + ''
    patch -p1 --reverse < ${fetchpatch {
      name = "fix-red-icons.diff"; # https://bugs.freedesktop.org/show_bug.cgi?id=99078
      url = https://github.com/llvm-mirror/llvm/commit/c280d74837d8.diff;
      sha256 = "11sq86spw41v72f676igksapdlsgh7fiqp5qkkmgfj0ndqcn9skf";
    }}
  ''
  # TSAN requires XPC on Darwin, which we have no public/free source files for. We can depend on the Apple frameworks
  # to get it, but they're unfree. Since LLVM is rather central to the stdenv, we patch out TSAN support so that Hydra
  # can build this. If we didn't do it, basically the entire nixpkgs on Darwin would have an unfree dependency and we'd
  # get no binary cache for the entire platform. If you really find yourself wanting the TSAN, make this controllable by
  # a flag and turn the flag off during the stdenv build. I realize that this LLVM isn't used in the stdenv but I want to
  # keep it consistent with 4.0. We really shouldn't be copying and pasting all this code around...
  + stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace ./projects/compiler-rt/cmake/config-ix.cmake \
      --replace 'set(COMPILER_RT_HAS_TSAN TRUE)' 'set(COMPILER_RT_HAS_TSAN FALSE)'
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
  ] ++ stdenv.lib.optionals (buildPlatform != hostPlatform) [
    "-DCMAKE_CROSSCOMPILING=True"
    "-DLLVM_TABLEGEN=${buildPackages.llvmPackages_39.llvm}/bin/llvm-tblgen"
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
    ln -s $lib/lib/libLLVM.dylib $lib/lib/libLLVM-${version}.dylib
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
