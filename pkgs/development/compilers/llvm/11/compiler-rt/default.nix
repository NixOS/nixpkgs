{ lib, stdenv, llvm_meta, version, fetch, cmake, python3, xcbuild, libllvm, libcxxabi, libxcrypt }:

let

  useLLVM = stdenv.hostPlatform.useLLVM or false;
  isNewDarwinBootstrap = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64;
  bareMetal = stdenv.hostPlatform.parsed.kernel.name == "none";
  haveLibc = stdenv.cc.libc != null;
  inherit (stdenv.hostPlatform) isMusl;

in

stdenv.mkDerivation {
  pname = "compiler-rt" + lib.optionalString (haveLibc) "-libc";
  inherit version;
  src = fetch "compiler-rt" "0x1j8ngf1zj63wlnns9vlibafq48qcm72p4jpaxkmkb4qw0grwfy";

  nativeBuildInputs = [ cmake python3 libllvm.dev ]
     ++ lib.optional stdenv.isDarwin xcbuild.xcrun;

  NIX_CFLAGS_COMPILE = [
    "-DSCUDO_DEFAULT_OPTIONS=DeleteSizeMismatch=0:DeallocationTypeMismatch=0"
  ];

  cmakeFlags = [
    "-DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON"
    "-DCMAKE_C_COMPILER_TARGET=${stdenv.hostPlatform.config}"
    "-DCMAKE_ASM_COMPILER_TARGET=${stdenv.hostPlatform.config}"
  ] ++ lib.optionals (haveLibc && !isMusl) [
    "-DSANITIZER_COMMON_CFLAGS=-I${libxcrypt}/include"
  ] ++ lib.optionals (useLLVM || bareMetal || isMusl || isNewDarwinBootstrap) [
    "-DCOMPILER_RT_BUILD_SANITIZERS=OFF"
    "-DCOMPILER_RT_BUILD_XRAY=OFF"
    "-DCOMPILER_RT_BUILD_LIBFUZZER=OFF"
    "-DCOMPILER_RT_BUILD_PROFILE=OFF"
  ] ++ lib.optionals (!haveLibc || bareMetal) [
    "-DCMAKE_C_COMPILER_WORKS=ON"
    "-DCMAKE_CXX_COMPILER_WORKS=ON"
    "-DCOMPILER_RT_BAREMETAL_BUILD=ON"
    "-DCMAKE_SIZEOF_VOID_P=${toString (stdenv.hostPlatform.parsed.cpu.bits / 8)}"
  ] ++ lib.optionals (!haveLibc) [
    "-DCMAKE_C_FLAGS=-nodefaultlibs"
  ] ++ lib.optionals (useLLVM || isNewDarwinBootstrap) [
    "-DCOMPILER_RT_BUILD_BUILTINS=ON"
    #https://stackoverflow.com/questions/53633705/cmake-the-c-compiler-is-not-able-to-compile-a-simple-test-program
    "-DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY"
  ] ++ lib.optionals (bareMetal) [
    "-DCOMPILER_RT_OS_DIR=baremetal"
  ] ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
    "-DDARWIN_macosx_OVERRIDE_SDK_VERSION=ON"
    "-DDARWIN_osx_ARCHS=${stdenv.hostPlatform.darwinArch}"
    "-DDARWIN_osx_BUILTIN_ARCHS=${stdenv.hostPlatform.darwinArch}"
  ];

  outputs = [ "out" "dev" ];

  patches = [
    ./codesign.patch # Revert compiler-rt commit that makes codesign mandatory
    ./X86-support-extension.patch # Add support for i486 i586 i686 by reusing i386 config
    ./gnu-install-dirs.patch
    # ld-wrapper dislikes `-rpath-link //nix/store`, so we normalize away the
    # extra `/`.
    ./normalize-var.patch
    ../../common/compiler-rt/libsanitizer-no-cyclades-11.patch
    ../../common/compiler-rt/darwin-plistbuddy-workaround.patch
    ./armv7l.patch
  ];

  preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    cmakeFlagsArray+=("-DCMAKE_LIPO=$(command -v ${stdenv.cc.targetPrefix}lipo)")
  '';

  # TSAN requires XPC on Darwin, which we have no public/free source files for. We can depend on the Apple frameworks
  # to get it, but they're unfree. Since LLVM is rather central to the stdenv, we patch out TSAN support so that Hydra
  # can build this. If we didn't do it, basically the entire nixpkgs on Darwin would have an unfree dependency and we'd
  # get no binary cache for the entire platform. If you really find yourself wanting the TSAN, make this controllable by
  # a flag and turn the flag off during the stdenv build.
  postPatch = lib.optionalString (!stdenv.isDarwin) ''
    substituteInPlace cmake/builtin-config-ix.cmake \
      --replace 'set(X86 i386)' 'set(X86 i386 i486 i586 i686)'
    substituteInPlace cmake/config-ix.cmake \
      --replace 'set(X86 i386)' 'set(X86 i386 i486 i586 i686)'
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace cmake/config-ix.cmake \
      --replace 'set(COMPILER_RT_HAS_TSAN TRUE)' 'set(COMPILER_RT_HAS_TSAN FALSE)'
  '' + lib.optionalString (useLLVM) ''
    substituteInPlace lib/builtins/int_util.c \
      --replace "#include <stdlib.h>" ""
    substituteInPlace lib/builtins/clear_cache.c \
      --replace "#include <assert.h>" ""
    substituteInPlace lib/builtins/cpu_model.c \
      --replace "#include <assert.h>" ""
  '';

  # Hack around weird upsream RPATH bug
  postInstall = lib.optionalString (stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isWasm) ''
    ln -s "$out/lib"/*/* "$out/lib"
  '' + lib.optionalString (useLLVM) ''
    ln -s $out/lib/*/clang_rt.crtbegin-*.o $out/lib/crtbegin.o
    ln -s $out/lib/*/clang_rt.crtend-*.o $out/lib/crtend.o
    ln -s $out/lib/*/clang_rt.crtbegin-*.o $out/lib/crtbeginS.o
    ln -s $out/lib/*/clang_rt.crtend-*.o $out/lib/crtendS.o
    ln -s $out/lib/*/clang_rt.crtbegin_shared-*.o $out/lib/crtbeginS.o
    ln -s $out/lib/*/clang_rt.crtend_shared-*.o $out/lib/crtendS.o
  ''
  # See https://reviews.llvm.org/D37278 for why android exception
  + lib.optionalString (stdenv.hostPlatform.isx86_32 && !stdenv.hostPlatform.isAndroid) ''
    for f in $out/lib/*/*builtins-i?86*; do
      ln -s "$f" $(echo "$f" | sed -e 's/builtins-i.86/builtins-i386/')
    done
  '';

  meta = llvm_meta // {
    homepage = "https://compiler-rt.llvm.org/";
    description = "Compiler runtime libraries";
    longDescription = ''
      The compiler-rt project provides highly tuned implementations of the
      low-level code generator support routines like "__fixunsdfdi" and other
      calls generated when a target doesn't have a short sequence of native
      instructions to implement a core IR operation. It also provides
      implementations of run-time libraries for dynamic testing tools such as
      AddressSanitizer, ThreadSanitizer, MemorySanitizer, and DataFlowSanitizer.
    '';
    # "All of the code in the compiler-rt project is dual licensed under the MIT
    # license and the UIUC License (a BSD-like license)":
    license = with lib.licenses; [ mit ncsa ];
    # compiler-rt requires a Clang stdenv on 32-bit RISC-V:
    # https://reviews.llvm.org/D43106#1019077
    broken = stdenv.hostPlatform.isRiscV && stdenv.hostPlatform.is32bit && !stdenv.cc.isClang;
  };
}
