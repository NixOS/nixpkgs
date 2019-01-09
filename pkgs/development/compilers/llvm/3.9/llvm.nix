{ stdenv
, fetch
, fetchpatch
, perl
, groff
, cmake
, python
, libffi
, libbfd
, libxml2
, ncurses
, version
, zlib
, compiler-rt_src
, debugVersion ? false
, enableSharedLibraries ? (stdenv.buildPlatform == stdenv.hostPlatform)
, buildPackages
}:

assert (stdenv.hostPlatform != stdenv.buildPlatform) -> !enableSharedLibraries;

let
  src = fetch "llvm" "1vi9sf7rx1q04wj479rsvxayb6z740iaz3qniwp266fgp5a07n8z";

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
  ];

  propagatedBuildInputs = [ ncurses zlib ];

  patches = [
    # fix output of llvm-config (fixed in llvm 4.0)
    (fetchpatch {
      url = https://github.com/llvm-mirror/llvm/commit/5340b5b3d970069aebf3dde49d8964583742e01a.patch;
      sha256 = "095f8knplwqbc2p7rad1kq8633i34qynni9jna93an7kyc80wdxl";
   })
   ] ++ stdenv.lib.optionals stdenv.hostPlatform.isMusl [
     ../TLI-musl.patch
     ../dynamiclibrary-musl.patch
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

    substituteInPlace CMakeLists.txt \
      --replace 'set(CMAKE_INSTALL_NAME_DIR "@rpath")' "set(CMAKE_INSTALL_NAME_DIR "$lib/lib")" \
      --replace 'set(CMAKE_INSTALL_RPATH "@executable_path/../lib")' ""
  ''
  # Patch llvm-config to return correct library path based on --link-{shared,static}.
  + stdenv.lib.optionalString (enableSharedLibraries) ''
    substitute '${./llvm-outputs.patch}' ./llvm-outputs.patch --subst-var lib
    patch -p1 < ./llvm-outputs.patch
  ''
  + ''
    (
      cd projects/compiler-rt
      patch -p1 < ${
        fetchpatch {
          name = "sigaltstack.patch"; # for glibc-2.26
          url = https://github.com/llvm-mirror/compiler-rt/commit/8a5e425a68d.diff;
          sha256 = "0h4y5vl74qaa7dl54b1fcyqalvlpd8zban2d1jxfkxpzyi7m8ifi";
        }
      }
      substituteInPlace lib/esan/esan_sideline_linux.cpp \
        --replace 'struct sigaltstack' 'stack_t'
    )
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

    "-DLLVM_HOST_TRIPLE=${stdenv.hostPlatform.config}"
    "-DLLVM_DEFAULT_TARGET_TRIPLE=${stdenv.targetPlatform.config}"
    "-DTARGET_TRIPLE=${stdenv.targetPlatform.config}"
  ] ++ stdenv.lib.optional enableSharedLibraries [
    "-DLLVM_LINK_LLVM_DYLIB=ON"
  ] ++ stdenv.lib.optional (!isDarwin)
    "-DLLVM_BINUTILS_INCDIR=${libbfd.dev}/include"
    ++ stdenv.lib.optionals (isDarwin) [
    "-DLLVM_ENABLE_LIBCXX=ON"
    "-DCAN_TARGET_i386=false"
  ] ++ stdenv.lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "-DCMAKE_CROSSCOMPILING=True"
    "-DLLVM_TABLEGEN=${buildPackages.llvmPackages_39.llvm}/bin/llvm-tblgen"
  ] ++ stdenv.lib.optionals stdenv.hostPlatform.isMusl [
    # Not yet supported
    "-DCOMPILER_RT_BUILD_SANITIZERS=OFF"
    "-DCOMPILER_RT_BUILD_XRAY=OFF"

  ];

  postBuild = ''
    rm -fR $out
  '';

  postInstall = ""
  + stdenv.lib.optionalString (enableSharedLibraries) ''
    moveToOutput "lib/libLLVM-*" "$lib"
    moveToOutput "lib/libLLVM${stdenv.hostPlatform.extensions.sharedLibrary}" "$lib"
    substituteInPlace "$out/lib/cmake/llvm/LLVMExports-release.cmake" \
      --replace "\''${_IMPORT_PREFIX}/lib/libLLVM-" "$lib/lib/libLLVM-"
  ''
  + stdenv.lib.optionalString (stdenv.isDarwin && enableSharedLibraries) ''
    substituteInPlace "$out/lib/cmake/llvm/LLVMExports-release.cmake" \
      --replace "\''${_IMPORT_PREFIX}/lib/libLLVM.dylib" "$lib/lib/libLLVM.dylib"
    ln -s $lib/lib/libLLVM.dylib $lib/lib/libLLVM-${shortVersion}.dylib
    ln -s $lib/lib/libLLVM.dylib $lib/lib/libLLVM-${version}.dylib
  '';

  enableParallelBuilding = true;

  passthru.src = src;

  meta = {
    description = "Collection of modular and reusable compiler and toolchain technologies";
    homepage    = http://llvm.org/;
    license     = stdenv.lib.licenses.ncsa;
    maintainers = with stdenv.lib.maintainers; [ lovek323 raskin ];
    platforms   = stdenv.lib.platforms.all;
  };
}
