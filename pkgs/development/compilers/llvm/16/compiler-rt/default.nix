{ lib, stdenv, llvm_meta, version
, monorepoSrc, runCommand
, cmake, ninja, python3, xcbuild, libllvm, linuxHeaders, libcxxabi, libxcrypt
, doFakeLibgcc ? stdenv.hostPlatform.isFreeBSD
}:

let

  useLLVM = stdenv.hostPlatform.useLLVM or false;
  bareMetal = stdenv.hostPlatform.parsed.kernel.name == "none";
  haveLibc = stdenv.cc.libc != null;
  isDarwinStatic = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isStatic;
  inherit (stdenv.hostPlatform) isMusl;

  baseName = "compiler-rt";

  src = runCommand "${baseName}-src-${version}" {} ''
    mkdir -p "$out"
    cp -r ${monorepoSrc}/cmake "$out"
    cp -r ${monorepoSrc}/${baseName} "$out"
  '';
in

stdenv.mkDerivation {
  pname = baseName + lib.optionalString (haveLibc) "-libc";
  inherit version;

  inherit src;
  sourceRoot = "${src.name}/${baseName}";

  nativeBuildInputs = [ cmake ninja python3 libllvm.dev ]
    ++ lib.optional stdenv.isDarwin xcbuild.xcrun;
  buildInputs =
    lib.optional (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isRiscV) linuxHeaders
    ++ lib.optional stdenv.hostPlatform.isDarwin libcxxabi;

  env.NIX_CFLAGS_COMPILE = toString ([
    "-DSCUDO_DEFAULT_OPTIONS=DeleteSizeMismatch=0:DeallocationTypeMismatch=0"
  ] ++ lib.optionals (!haveLibc) [
    # The compiler got stricter about this, and there is a usellvm patch below
    # which patches out the assert include causing an implicit definition of
    # assert. It would be nicer to understand why compiler-rt thinks it should
    # be able to #include <assert.h> in the first place; perhaps it's in the
    # wrong, or perhaps there is a way to provide an assert.h.
    "-Wno-error=implicit-function-declaration"
  ]);

  cmakeFlags = [
    "-DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON"
    "-DCMAKE_C_COMPILER_TARGET=${stdenv.hostPlatform.config}"
    "-DCMAKE_ASM_COMPILER_TARGET=${stdenv.hostPlatform.config}"
  ] ++ lib.optionals (haveLibc && stdenv.hostPlatform.libc == "glibc") [
    "-DSANITIZER_COMMON_CFLAGS=-I${libxcrypt}/include"
  ] ++ lib.optionals (useLLVM || bareMetal || isMusl || isDarwinStatic) [
    "-DCOMPILER_RT_BUILD_SANITIZERS=OFF"
    "-DCOMPILER_RT_BUILD_XRAY=OFF"
    "-DCOMPILER_RT_BUILD_LIBFUZZER=OFF"
    "-DCOMPILER_RT_BUILD_MEMPROF=OFF"
    "-DCOMPILER_RT_BUILD_ORC=OFF" # may be possible to build with musl if necessary
  ] ++ lib.optionals (useLLVM || bareMetal) [
     "-DCOMPILER_RT_BUILD_PROFILE=OFF"
  ] ++ lib.optionals ((useLLVM && !haveLibc) || bareMetal || isDarwinStatic ) [
    "-DCMAKE_CXX_COMPILER_WORKS=ON"
  ] ++ lib.optionals ((useLLVM && !haveLibc) || bareMetal) [
    "-DCMAKE_C_COMPILER_WORKS=ON"
    "-DCOMPILER_RT_BAREMETAL_BUILD=ON"
    "-DCMAKE_SIZEOF_VOID_P=${toString (stdenv.hostPlatform.parsed.cpu.bits / 8)}"
  ] ++ lib.optionals (useLLVM && !haveLibc) [
    "-DCMAKE_C_FLAGS=-nodefaultlibs"
  ] ++ lib.optionals (useLLVM) [
    "-DCOMPILER_RT_BUILD_BUILTINS=ON"
    #https://stackoverflow.com/questions/53633705/cmake-the-c-compiler-is-not-able-to-compile-a-simple-test-program
    "-DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY"
  ] ++ lib.optionals (bareMetal) [
    "-DCOMPILER_RT_OS_DIR=baremetal"
  ] ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
    "-DCMAKE_LIPO=${lib.getBin stdenv.cc.bintools.bintools}/bin/${stdenv.cc.targetPrefix}lipo"
    "-DDARWIN_macosx_OVERRIDE_SDK_VERSION=ON"
    "-DDARWIN_osx_ARCHS=${stdenv.hostPlatform.darwinArch}"
    "-DDARWIN_osx_BUILTIN_ARCHS=${stdenv.hostPlatform.darwinArch}"

    # `COMPILER_RT_DEFAULT_TARGET_ONLY` does not apply to Darwin:
    # https://github.com/llvm/llvm-project/blob/27ef42bec80b6c010b7b3729ed0528619521a690/compiler-rt/cmake/base-config-ix.cmake#L153
    "-DCOMPILER_RT_ENABLE_IOS=OFF"
  ];

  outputs = [ "out" "dev" ];

  patches = [
    ./X86-support-extension.patch # Add support for i486 i586 i686 by reusing i386 config
    ./gnu-install-dirs.patch
    # ld-wrapper dislikes `-rpath-link //nix/store`, so we normalize away the
    # extra `/`.
    ./normalize-var.patch
    # Prevent a compilation error on darwin
    ./darwin-targetconditionals.patch
    # See: https://github.com/NixOS/nixpkgs/pull/186575
    ../../common/compiler-rt/darwin-plistbuddy-workaround.patch
    # See: https://github.com/NixOS/nixpkgs/pull/194634#discussion_r999829893
    # ../../common/compiler-rt/armv7l-15.patch
  ];

  # TSAN requires XPC on Darwin, which we have no public/free source files for. We can depend on the Apple frameworks
  # to get it, but they're unfree. Since LLVM is rather central to the stdenv, we patch out TSAN support so that Hydra
  # can build this. If we didn't do it, basically the entire nixpkgs on Darwin would have an unfree dependency and we'd
  # get no binary cache for the entire platform. If you really find yourself wanting the TSAN, make this controllable by
  # a flag and turn the flag off during the stdenv build.
  postPatch = lib.optionalString (!stdenv.isDarwin) ''
    substituteInPlace cmake/builtin-config-ix.cmake \
      --replace 'set(X86 i386)' 'set(X86 i386 i486 i586 i686)'
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace cmake/config-ix.cmake \
      --replace 'set(COMPILER_RT_HAS_TSAN TRUE)' 'set(COMPILER_RT_HAS_TSAN FALSE)'
  '' + lib.optionalString (useLLVM && !haveLibc) ''
    substituteInPlace lib/builtins/int_util.c \
      --replace "#include <stdlib.h>" ""
    substituteInPlace lib/builtins/clear_cache.c \
      --replace "#include <assert.h>" ""
    substituteInPlace lib/builtins/cpu_model.c \
      --replace "#include <assert.h>" ""
  '';

  # Hack around weird upsream RPATH bug
  postInstall = lib.optionalString (stdenv.hostPlatform.isDarwin) ''
    ln -s "$out/lib"/*/* "$out/lib"
  '' + lib.optionalString (useLLVM && stdenv.hostPlatform.isLinux) ''
    ln -s $out/lib/*/clang_rt.crtbegin-*.o $out/lib/crtbegin.o
    ln -s $out/lib/*/clang_rt.crtend-*.o $out/lib/crtend.o
    # Note the history of crt{begin,end}S in previous versions of llvm in nixpkg:
    # The presence of crtbegin_shared has been added and removed; it's possible
    # people have added/removed it to get it working on their platforms.
    # Try each in turn for now.
    ln -s $out/lib/*/clang_rt.crtbegin-*.o $out/lib/crtbeginS.o
    ln -s $out/lib/*/clang_rt.crtend-*.o $out/lib/crtendS.o
    ln -s $out/lib/*/clang_rt.crtbegin_shared-*.o $out/lib/crtbeginS.o
    ln -s $out/lib/*/clang_rt.crtend_shared-*.o $out/lib/crtendS.o
  '' + lib.optionalString doFakeLibgcc ''
     ln -s $out/lib/freebsd/libclang_rt.builtins-*.a $out/lib/libgcc.a
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
    broken = stdenv.hostPlatform.isRiscV32 && !stdenv.cc.isClang;
  };
}
