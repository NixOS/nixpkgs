{
  lib,
  llvm_meta,
  monorepoSrc,
  release_version,
  runCommand,
  cmake,
  libxml2,
  libllvm,
  ninja,
  libffi,
  libclang,
  stdenv,
  clang,
  mlir,
  version,
  python3,
  buildLlvmTools,
  devExtraCmakeFlags ? [ ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flang";
  inherit version;

  src = runCommand "flang-src-${version}" { inherit (monorepoSrc) passthru; } ''
    mkdir -p "$out"
    cp -r ${monorepoSrc}/${finalAttrs.pname} "$out"
    cp -r ${monorepoSrc}/cmake "$out"
    cp -r ${monorepoSrc}/llvm "$out"
    cp -r ${monorepoSrc}/clang "$out"
    cp -r ${monorepoSrc}/mlir "$out"
    cp -r ${monorepoSrc}/third-party "$out"
    chmod -R +w $out/llvm
  '';

  patches = [
    ./dummy_target_19+.patch
  ];
  patchFlags = [ "-p2" ];

  sourceRoot = "${finalAttrs.src.name}/flang";

  buildInputs = [
    libffi
    libxml2
    libllvm
    libclang
    mlir
  ];
  nativeBuildInputs = [
    cmake
    clang
    ninja
    python3
    libllvm.dev
    mlir.dev
  ];
  preConfigure = ''
    ls -l ${libllvm.dev}/lib/cmake/llvm/LLVMConfig.cmake
    ls -l ${libclang.dev}/lib/cmake/clang/ClangConfig.cmake
    ls -l ${mlir.dev}/lib/cmake/mlir/MLIRConfig.cmake
  '';
  cmakeFlags = [
    (lib.cmakeBool "CMAKE_VERBOSE_MAKEFILE" true)
    (lib.cmakeFeature "LLVM_DIR" "${libllvm.dev}/lib/cmake/llvm")
    (lib.cmakeFeature "LLVM_TOOLS_BINARY_DIR" "${buildLlvmTools.tblgen}/bin/")
    (lib.cmakeFeature "LLVM_EXTERNAL_LIT" "${buildLlvmTools.tblgen}/bin/llvm-lit")
    (lib.cmakeFeature "CLANG_DIR" "${libclang.dev}/lib/cmake/clang")
    (lib.cmakeFeature "MLIR_DIR" "${mlir.dev}/lib/cmake/mlir")
    (lib.cmakeFeature "MLIR_TABLEGEN_EXE" "${buildLlvmTools.tblgen}/bin/mlir-tblgen")
    (lib.cmakeFeature "MLIR_TABLEGEN_TARGET" "MLIR-TBLGen")
    (lib.cmakeBool "LLVM_BUILD_EXAMPLES" false)
    (lib.cmakeBool "LLVM_ENABLE_PLUGINS" false)
    (lib.cmakeBool "FLANG_STANDALONE_BUILD" true)
    (lib.cmakeBool "LLVM_INCLUDE_EXAMPLES" false)
    (lib.cmakeBool "FLANG_INCLUDE_TESTS" false)

  ]
  ++ devExtraCmakeFlags;

  postUnpack = ''
    chmod -R u+w -- $sourceRoot/..
  '';

  outputs = [ "out" ];
  requiredSystemFeatures = [ "big-parallel" ];
  meta = llvm_meta // {
    homepage = "https://flang.llvm.org/";
    description = "LLVM-based Fortran frontend";
    license = lib.licenses.ncsa;
    mainProgram = "flang";
    maintainers = with lib.maintainers; [ acture ];
  };
})
