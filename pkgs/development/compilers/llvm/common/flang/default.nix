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
  libxml2,
  python3,
  lit,
  mlir,
  ninja,
  version,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "flang";
  inherit version;

  src =

    if monorepoSrc != null then
      runCommand "${finalAttrs.pname}-src-${finalAttrs.version}"
        {
          inherit (monorepoSrc) passthru;
        }
        ''
          mkdir -p "$out"
          cp -r ${monorepoSrc}/cmake "$out"
          cp -r ${monorepoSrc}/flang-rt "$out"
          cp -r ${monorepoSrc}/${finalAttrs.pname} "$out"
        ''
    else
      src;

  sourceRoot = "${finalAttrs.src.name}/${finalAttrs.pname}";

  nativeBuildInputs = [
    cmake
    ninja
    python3
  ];
  buildInputs = [
    libclang
    libllvm
    libxml2
    mlir
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CLANG_DIR" "${libclang.dev}/lib/cmake/clang")
    (lib.cmakeFeature "MLIR_DIR" "${mlir.dev}/lib/cmake/mlir")
    (lib.cmakeFeature "LLVM_DIR" "${libllvm.dev}/lib/cmake/llvm")
    (lib.cmakeBool "MLIR_LINK_MLIR_DYLIB" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeFeature "LLVM_EXTERNAL_LIT" "${lit}/bin/lit")
    (lib.cmakeFeature "LLVM_LIT_ARGS" "-v")
    # Tests depend on test libs from MLIR which are only available in a
    # build tree.
    (lib.cmakeBool "FLANG_INCLUDE_TESTS" false)
  ];

  passthru = {
    # Used by cc-wrapper to determine whether or not the default setup hook is enabled.
    langC = false;
    langCC = false;
    langFortran = true;
    isClang = true;

    hardeningUnsupportedFlags = [
      "zerocallusedregs"
      "stackprotector"
    ];
  };

  meta = llvm_meta // {
    homepage = "https://flang.llvm.org";
    description = "LLVM Fortran Compiler";
  };
})
