{
  lib,
  stdenv,
  llvm_meta,
  src ? null,
  monorepoSrc ? null,
  runCommand,
  release_version,
  version,
  cmake,
  ninja,
  libllvm,
  python3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "llvm-libgcc";
  inherit version;

  src =
    if monorepoSrc != null then
      runCommand "llvm-libgcc-src-${version}" { inherit (monorepoSrc) passthru; } (''
        mkdir -p "$out"
        cp -r ${monorepoSrc}/cmake "$out"
        cp -r ${monorepoSrc}/llvm-libgcc "$out"
        cp -r ${monorepoSrc}/compiler-rt "$out"
        cp -r ${monorepoSrc}/libunwind "$out"
        cp -r ${monorepoSrc}/runtimes "$out"
        cp -r ${monorepoSrc}/third-party "$out"
      '')
    else
      src;

  sourceRoot = "${finalAttrs.src.name}/llvm-libgcc";

  cmakeFlags = [
    (lib.cmakeBool "LLVM_LIBGCC_EXPLICIT_OPT_IN" true)
    (lib.cmakeBool "COMPILER_RT_USE_LLVM_UNWINDER" stdenv.hostPlatform.useLLVM)
  ];

  outputs = [
    "out"
    "dev"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake
    ninja
    libllvm.dev
    python3
  ];

  meta = llvm_meta // {
    description = "GCC compatibility for LLVM";
  };
})
