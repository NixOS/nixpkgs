{
  lib,
  stdenv,
  release_version,
  src ? null,
  llvm_meta,
  version,
  monorepoSrc ? null,
  runCommand,
  cmake,
  ninja,
  python3,
  libcxx,
  fetchpatch,
  enableShared ? !stdenv.hostPlatform.isStatic,
  doFakeLibgcc ? stdenv.hostPlatform.useLLVM && !stdenv.hostPlatform.isStatic,
  devExtraCmakeFlags ? [ ],
  getVersionFile,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libunwind";

  inherit version;

  src =
    if monorepoSrc != null then
      runCommand "libunwind-src-${version}" { inherit (monorepoSrc) passthru; } ''
        mkdir -p "$out"
        cp -r ${monorepoSrc}/cmake "$out"
        cp -r ${monorepoSrc}/libunwind "$out"
        mkdir -p "$out/libcxx"
        cp -r ${monorepoSrc}/libcxx/cmake "$out/libcxx"
        cp -r ${monorepoSrc}/libcxx/utils "$out/libcxx"
        mkdir -p "$out/llvm"
        cp -r ${monorepoSrc}/llvm/cmake "$out/llvm"
        cp -r ${monorepoSrc}/llvm/utils "$out/llvm"
        cp -r ${monorepoSrc}/runtimes "$out"
      ''
    else
      src;

  sourceRoot = "${finalAttrs.src.name}/runtimes";

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    ninja
    python3
  ];

  cmakeFlags = [
    (lib.cmakeBool "LIBUNWIND_ENABLE_SHARED" enableShared)
    (lib.cmakeFeature "LLVM_ENABLE_RUNTIMES" "libunwind")
  ]
  ++ lib.optionals stdenv.hostPlatform.isWasm [
    # Required otherwise CMake fails to determine platform
    (lib.cmakeBool "UNIX" true)
  ]
  ++ devExtraCmakeFlags;

  env = lib.optionalAttrs stdenv.hostPlatform.isWasm {
    # New EH model is needed for Unwind-wasm.c
    NIX_CFLAGS_COMPILE = "-fwasm-exceptions -mllvm -wasm-use-legacy-eh=false";
  };

  # https://github.com/llvm/llvm-project/pull/168449
  prePatch = lib.optionalString stdenv.hostPlatform.isWasm ''
    chmod -R +w ../libunwind/src
  '';
  patches = lib.optionals stdenv.hostPlatform.isWasm [
    (fetchpatch {
      url = "https://gist.githubusercontent.com/yamt/b699eb2604d2598810a2876ff2ffc8d8/raw/1bc7d7d7c5cb4b37893415521528ae1c8f77b054/a.diff";
      hash = "sha256-Z2wbPs59rFBa0ki6DeoAULQfU/V800QcIxj99jofjLs=";
    })
  ];
  patchFlags = lib.optionals stdenv.hostPlatform.isWasm [
    "-p1"
    "-d"
    ".."
  ];

  postInstall =
    lib.optionalString (enableShared && !stdenv.hostPlatform.isDarwin && !stdenv.hostPlatform.isWindows)
      ''
        # libcxxabi wants to link to libunwind_shared.so (?).
        ln -s $out/lib/libunwind.so $out/lib/libunwind_shared.so
      ''
    + lib.optionalString (enableShared && stdenv.hostPlatform.isWindows) ''
      ln -s $out/lib/libunwind.dll.a $out/lib/libunwind_shared.dll.a
    ''
    + lib.optionalString (doFakeLibgcc && !stdenv.hostPlatform.isWindows) ''
      ln -s $out/lib/libunwind.so $out/lib/libgcc_s.so
      ln -s $out/lib/libunwind.so $out/lib/libgcc_s.so.1
    ''
    + lib.optionalString (doFakeLibgcc && stdenv.hostPlatform.isWindows) ''
      ln -s $out/lib/libunwind.dll.a $out/lib/libgcc_s.dll.a
    '';

  meta = llvm_meta // {
    # Details: https://github.com/llvm/llvm-project/blob/main/libunwind/docs/index.rst
    homepage = "https://clang.llvm.org/docs/Toolchain.html#unwind-library";
    description = "LLVM's unwinder library";
    longDescription = ''
      The unwind library provides a family of _Unwind_* functions implementing
      the language-neutral stack unwinding portion of the Itanium C++ ABI (Level
      I). It is a dependency of the C++ ABI library, and sometimes is a
      dependency of other runtimes.
    '';
  };
})
