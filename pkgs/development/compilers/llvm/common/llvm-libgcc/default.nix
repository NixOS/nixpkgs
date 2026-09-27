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
      runCommand "llvm-libgcc-src-${version}" { inherit (monorepoSrc) passthru; } ''
        mkdir -p "$out"
        cp -r ${monorepoSrc}/cmake "$out"
        cp -r ${monorepoSrc}/llvm-libgcc "$out"
        cp -r ${monorepoSrc}/compiler-rt "$out"
        cp -r ${monorepoSrc}/libunwind "$out"
        cp -r ${monorepoSrc}/runtimes "$out"
        cp -r ${monorepoSrc}/third-party "$out"
      ''
    else
      src;

  sourceRoot = "${finalAttrs.src.name}/llvm-libgcc";

  cmakeFlags = [
    (lib.cmakeBool "LLVM_LIBGCC_EXPLICIT_OPT_IN" true)
    (lib.cmakeBool "COMPILER_RT_USE_LLVM_UNWINDER" stdenv.hostPlatform.useLLVM)
    # Skip CMake's compiler link test — the bootstrap compiler may not be
    # able to link executables yet (no libgcc_s), which is what we're building.
    (lib.cmakeBool "CMAKE_C_COMPILER_WORKS" true)
    (lib.cmakeBool "CMAKE_CXX_COMPILER_WORKS" true)
    (lib.cmakeBool "CMAKE_ASM_COMPILER_WORKS" true)
    # Only build builtins — sanitizers need C++ headers (libc++) which are
    # not available at this bootstrap stage.  The full compiler-rt with
    # sanitizers is built separately as compiler-rt-libc.
    (lib.cmakeBool "COMPILER_RT_BUILD_SANITIZERS" false)
    (lib.cmakeBool "COMPILER_RT_BUILD_XRAY" false)
    (lib.cmakeBool "COMPILER_RT_BUILD_LIBFUZZER" false)
    (lib.cmakeBool "COMPILER_RT_BUILD_PROFILE" false)
    (lib.cmakeBool "COMPILER_RT_BUILD_MEMPROF" false)
    (lib.cmakeBool "COMPILER_RT_BUILD_ORC" false)
    (lib.cmakeBool "COMPILER_RT_BUILD_CTX_PROFILE" false)
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
