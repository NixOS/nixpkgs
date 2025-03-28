{
  lib,
  stdenv,
  llvm_meta,
  src ? null,
  monorepoSrc ? null,
  runCommand,
  cmake,
  libclang,
  libllvm,
  mlir,
  ninja,
  python3,
  flang-unwrapped,
  version,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "flang-rt";
  inherit version;

  src =
    if monorepoSrc != null then
      runCommand "${finalAttrs.pname}-src-${version}"
        {
          inherit (monorepoSrc) passthru;
        }
        (''
          mkdir -p "$out"
          cp -r ${monorepoSrc}/cmake "$out"

          mkdir -p "$out/llvm"
          cp -r ${monorepoSrc}/llvm/cmake "$out/llvm"
          cp -r ${monorepoSrc}/llvm/utils "$out/llvm"
          cp -r ${monorepoSrc}/third-party "$out"

          cp -r ${monorepoSrc}/${finalAttrs.pname} "$out"
          cp -r ${monorepoSrc}/flang "$out"
          cp -r ${monorepoSrc}/runtimes "$out"
        '')
    else
      src;

  sourceRoot = "${finalAttrs.src.name}/runtimes";

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    flang-unwrapped
    cmake
    ninja
    python3
  ];
  buildInputs = [
    libclang
    libllvm
    mlir
  ];

  cmakeFlags = [
    (lib.cmakeFeature "LLVM_DEFAULT_TARGET_TRIPLE" stdenv.hostPlatform.config)
    (lib.cmakeFeature "CMAKE_Fortran_COMPILER" "${flang-unwrapped}/bin/flang")
    (lib.cmakeBool "CMAKE_Fortran_COMPILER_WORKS" true)
    (lib.cmakeBool "CMAKE_Fortran_COMPILER_SUPPORTS_F90" true)
    (lib.cmakeFeature "CLANG_DIR" "${libclang.dev}/lib/cmake/clang")
    (lib.cmakeFeature "MLIR_DIR" "${mlir.dev}/lib/cmake/mlir")
    (lib.cmakeFeature "LLVM_DIR" "${libllvm.dev}/lib/cmake/llvm")
    (lib.cmakeFeature "LLVM_ENABLE_RUNTIMES" "flang-rt")
  ];

  meta = llvm_meta // {
    homepage = "https://flang.llvm.org";
    description = "LLVM Fortran Runtime";
  };
})
