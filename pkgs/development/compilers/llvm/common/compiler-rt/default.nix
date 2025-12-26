{
  lib,
  stdenv,
  llvm_meta,
  release_version,
  version,
  src ? null,
  monorepoSrc ? null,
  runCommand,
  cmake,
  ninja,
  python3,
  libllvm,
  jq,
  libcxx,
  linuxHeaders,
  freebsd,

  # Some platforms have switched to using compiler-rt, but still want a
  # libgcc.a for ABI compat purposes. The use case would be old code that
  # expects to link `-lgcc` but doesn't care exactly what its contents
  # are, so long as it provides some builtins.
  doFakeLibgcc ? stdenv.hostPlatform.isFreeBSD,

  # In recent releases, the compiler-rt build seems to produce
  # many `libclang_rt*` libraries, but not a single unified
  # `libcompiler_rt` library, at least under certain configurations. Some
  # platforms still expect this, however, so we symlink one into place.
  forceLinkCompilerRt ? stdenv.hostPlatform.isOpenBSD,
  devExtraCmakeFlags ? [ ],
  getVersionFile,
  fetchpatch,
}:

let

  useLLVM = stdenv.hostPlatform.useLLVM or false;
  bareMetal = stdenv.hostPlatform.parsed.kernel.name == "none";
  haveLibc = stdenv.cc.libc != null;
  # TODO: Make this account for GCC having libstdcxx, which will help
  # use clean up the `cmakeFlags` rats nest below.
  haveLibcxx = stdenv.cc.libcxx != null;
  isDarwinStatic = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isStatic;
  inherit (stdenv.hostPlatform) isMusl isAarch64 isWindows;
  noSanitizers = !haveLibc || bareMetal || isMusl || isDarwinStatic || isWindows;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "compiler-rt${lib.optionalString haveLibc "-libc"}";
  inherit version;

  src =
    if monorepoSrc != null then
      runCommand "compiler-rt-src-${version}" { inherit (monorepoSrc) passthru; } (
        ''
          mkdir -p "$out"
          cp -r ${monorepoSrc}/cmake "$out"
        ''
        + lib.optionalString (lib.versionAtLeast release_version "21") ''
          cp -r ${monorepoSrc}/third-party "$out"
        ''
        + ''
          cp -r ${monorepoSrc}/compiler-rt "$out"
        ''
      )
    else
      src;

  sourceRoot = "${finalAttrs.src.name}/compiler-rt";

  patches = [
    (getVersionFile "compiler-rt/X86-support-extension.patch") # Add support for i486 i586 i686 by reusing i386 config
    # ld-wrapper dislikes `-rpath-link //nix/store`, so we normalize away the
    # extra `/`.
    (getVersionFile "compiler-rt/normalize-var.patch")
    # Fix build on armv6l
    ./armv6-no-ldrexd-strexd.patch
    # See: https://github.com/NixOS/nixpkgs/pull/186575
    ./darwin-plistbuddy-workaround.patch
  ]
  ++ [
    (getVersionFile "compiler-rt/armv6-scudo-libatomic.patch")
  ]
  ++ lib.optional (lib.versions.major release_version == "19") (fetchpatch {
    url = "https://github.com/llvm/llvm-project/pull/99837/commits/14ae0a660a38e1feb151928a14f35ff0f4487351.patch";
    hash = "sha256-JykABCaNNhYhZQxCvKiBn54DZ5ZguksgCHnpdwWF2no=";
    relative = "compiler-rt";
  });

  nativeBuildInputs = [
    cmake
    python3
    libllvm.dev
    ninja
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ jq ];
  buildInputs =
    lib.optional (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isRiscV) linuxHeaders
    ++ lib.optional (stdenv.hostPlatform.isFreeBSD) freebsd.include;

  env = {
    NIX_CFLAGS_COMPILE = toString (
      [
        "-DSCUDO_DEFAULT_OPTIONS=delete_size_mismatch=false:dealloc_type_mismatch=false"
      ]
      ++ lib.optionals (!haveLibc) [
        # The compiler got stricter about this, and there is a usellvm patch below
        # which patches out the assert include causing an implicit definition of
        # assert. It would be nicer to understand why compiler-rt thinks it should
        # be able to #include <assert.h> in the first place; perhaps it's in the
        # wrong, or perhaps there is a way to provide an assert.h.
        "-Wno-error=implicit-function-declaration"
      ]
    );

    # Work around clang’s trying to invoke unprefixed-ld on Darwin when `-target` is passed.
    NIX_CFLAGS_LINK = lib.optionalString (stdenv.hostPlatform.isDarwin) "--ld-path=${stdenv.cc.bintools}/bin/${stdenv.cc.targetPrefix}ld";
  };

  cmakeFlags = [
    (lib.cmakeBool "COMPILER_RT_DEFAULT_TARGET_ONLY" true)
    (lib.cmakeFeature "CMAKE_C_COMPILER_TARGET" stdenv.hostPlatform.config)
    (lib.cmakeFeature "CMAKE_ASM_COMPILER_TARGET" stdenv.hostPlatform.config)
  ]
  ++ lib.optionals (useLLVM && haveLibc && stdenv.cc.libcxx == libcxx) [
    (lib.cmakeFeature "SANITIZER_CXX_ABI" "libcxxabi")
    (lib.cmakeFeature "SANITIZER_CXX_ABI_LIBNAME" "libcxxabi")
    (lib.cmakeBool "COMPILER_RT_USE_BUILTINS_LIBRARY" true)
  ]
  ++ lib.optionals (useLLVM && haveLibc) [
    (lib.cmakeBool "COMPILER_RT_BUILD_SANITIZERS" true)
    (lib.cmakeBool "COMPILER_RT_BUILD_PROFILE" true)
  ]
  ++ lib.optionals noSanitizers [
    (lib.cmakeBool "COMPILER_RT_BUILD_SANITIZERS" false)
  ]
  ++ lib.optionals ((useLLVM && !haveLibcxx) || !haveLibc || bareMetal || isMusl || isDarwinStatic) [
    (lib.cmakeBool "COMPILER_RT_BUILD_XRAY" false)
    (lib.cmakeBool "COMPILER_RT_BUILD_LIBFUZZER" false)
    (lib.cmakeBool "COMPILER_RT_BUILD_MEMPROF" false)
    (lib.cmakeBool "COMPILER_RT_BUILD_ORC" false) # may be possible to build with musl if necessary
  ]
  ++ lib.optionals (!haveLibc || bareMetal) [
    (lib.cmakeBool "COMPILER_RT_BUILD_PROFILE" false)
    (lib.cmakeBool "CMAKE_C_COMPILER_WORKS" true)
    (lib.cmakeBool "COMPILER_RT_BAREMETAL_BUILD" true)
    (lib.cmakeFeature "CMAKE_SIZEOF_VOID_P" (toString (stdenv.hostPlatform.parsed.cpu.bits / 8)))
  ]
  ++ lib.optionals (!haveLibc || bareMetal || isDarwinStatic) [
    (lib.cmakeBool "CMAKE_CXX_COMPILER_WORKS" true)
  ]
  ++ lib.optionals (!haveLibc) [
    (lib.cmakeFeature "CMAKE_C_FLAGS" "-nodefaultlibs")
  ]
  ++ lib.optionals useLLVM [
    (lib.cmakeBool "COMPILER_RT_BUILD_BUILTINS" true)
    #https://stackoverflow.com/questions/53633705/cmake-the-c-compiler-is-not-able-to-compile-a-simple-test-program
    (lib.cmakeFeature "CMAKE_TRY_COMPILE_TARGET_TYPE" "STATIC_LIBRARY")
  ]
  ++ lib.optionals bareMetal [
    (lib.cmakeFeature "COMPILER_RT_OS_DIR" "baremetal")
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin) (
    [
      (lib.cmakeFeature "CMAKE_LIPO" "${lib.getBin stdenv.cc.bintools.bintools}/bin/${stdenv.cc.targetPrefix}lipo")
    ]
    ++ lib.optionals (!haveLibcxx) [
      # Darwin fails to detect that the compiler supports the `-g` flag when there is no libc++ during the
      # compiler-rt bootstrap, which prevents compiler-rt from building. The `-g` flag is required by the
      # Darwin support, so force it to be enabled during the first stage of the compiler-rt bootstrap.
      (lib.cmakeBool "COMPILER_RT_HAS_G_FLAG" true)
    ]
    ++ [
      (lib.cmakeFeature "DARWIN_osx_ARCHS" stdenv.hostPlatform.darwinArch)
      (lib.cmakeFeature "DARWIN_osx_BUILTIN_ARCHS" stdenv.hostPlatform.darwinArch)
      (lib.cmakeFeature "SANITIZER_MIN_OSX_VERSION" stdenv.hostPlatform.darwinMinVersion)
      # `COMPILER_RT_DEFAULT_TARGET_ONLY` does not apply to Darwin:
      # https://github.com/llvm/llvm-project/blob/27ef42bec80b6c010b7b3729ed0528619521a690/compiler-rt/cmake/base-config-ix.cmake#L153
      (lib.cmakeBool "COMPILER_RT_ENABLE_IOS" false)
    ]
  )
  ++ lib.optionals (noSanitizers && lib.versionAtLeast release_version "19") [
    (lib.cmakeBool "COMPILER_RT_BUILD_CTX_PROFILE" false)
  ]
  ++
    lib.optional (stdenv.hostPlatform.isAarch64 && !haveLibc)
      # Fixes https://github.com/NixOS/nixpkgs/issues/393603
      (lib.cmakeBool "COMPILER_RT_DISABLE_AARCH64_FMV" true)
  ++ devExtraCmakeFlags;

  outputs = [
    "out"
    "dev"
  ];

  postPatch =
    lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      substituteInPlace cmake/builtin-config-ix.cmake \
        --replace-fail 'set(X86 i386)' 'set(X86 i386 i486 i586 i686)'
    ''
    + lib.optionalString (!haveLibc) (
      (lib.optionalString (lib.versions.major release_version == "18") ''
        substituteInPlace lib/builtins/aarch64/sme-libc-routines.c \
          --replace-fail "<stdlib.h>" "<stddef.h>"
      '')
      + ''
        substituteInPlace lib/builtins/int_util.c \
          --replace-fail "#include <stdlib.h>" ""
      ''
      + (lib.optionalString (!stdenv.hostPlatform.isFreeBSD)
        # On FreeBSD, assert/static_assert are macros and allowing them to be implicitly declared causes link errors.
        # see description above for why we're nuking assert.h normally but that doesn't work here.
        # instead, we add the freebsd.include dependency explicitly
        ''
          substituteInPlace lib/builtins/clear_cache.c \
            --replace-fail "#include <assert.h>" ""
          substituteInPlace lib/builtins/cpu_model/x86.c \
            --replace-fail "#include <assert.h>" ""
        ''
      )
    )
    +
      lib.optionalString (lib.versionAtLeast release_version "19")
        # codesign in sigtool doesn't support the various options used by the build
        # and is present in the bootstrap-tools. Removing find_program prevents the
        # build from trying to use it and failing.
        ''
          substituteInPlace cmake/Modules/AddCompilerRT.cmake \
            --replace-fail 'find_program(CODESIGN codesign)' ""
        '';

  preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    cmakeFlagsArray+=(
      "-DDARWIN_macosx_CACHED_SYSROOT=$SDKROOT"
      "-DDARWIN_macosx_OVERRIDE_SDK_VERSION=$(jq -r .Version "$SDKROOT/SDKSettings.json")"
    )
  '';

  # Hack around weird upstream RPATH bug
  postInstall =
    lib.optionalString (stdenv.hostPlatform.isDarwin) ''
      ln -s "$out/lib"/*/* "$out/lib"
    ''
    + lib.optionalString (useLLVM && stdenv.hostPlatform.isLinux) ''
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
    ''
    + lib.optionalString doFakeLibgcc ''
      ln -s $out/lib/*/libclang_rt.builtins-*.a $out/lib/libgcc.a
    ''
    + lib.optionalString forceLinkCompilerRt ''
      ln -s $out/lib/*/libclang_rt.builtins-*.a $out/lib/libcompiler_rt.a
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
    license = with lib.licenses; [
      mit
      ncsa
    ];
    broken =
      # compiler-rt requires a Clang stdenv on 32-bit RISC-V:
      # https://reviews.llvm.org/D43106#1019077
      (stdenv.hostPlatform.isRiscV32 && !stdenv.cc.isClang)
      # emutls wants `<pthread.h>` which isn't available (without experimental WASM threads proposal).
      # `enable_execute_stack.c` Also doesn't sound like something WASM would support.
      || (stdenv.hostPlatform.isWasm && haveLibc);
  };
})
