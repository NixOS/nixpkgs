{
  lib,
  stdenv,
  llvm_meta,
  release_version,
  buildLlvmTools,
  monorepoSrc,
  runCommand,
  cmake,
  ninja,
  libxml2,
  libllvm,
  version,
  devExtraCmakeFlags ? [ ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mlir";
  inherit version;

  doCheck =
    (
      !stdenv.hostPlatform.isx86_32 # TODO: why
    )
    && (!stdenv.hostPlatform.isMusl);

  # Blank llvm dir just so relative path works
  src = runCommand "${finalAttrs.pname}-src-${version}" { inherit (monorepoSrc) passthru; } ''
    mkdir -p "$out"
    cp -r ${monorepoSrc}/cmake "$out"
    cp -r ${monorepoSrc}/mlir "$out"
    cp -r ${monorepoSrc}/third-party "$out/third-party"

    mkdir -p "$out/llvm"
  '';

  sourceRoot = "${finalAttrs.src.name}/mlir";

  patches = [
    ./gnu-install-dirs.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    libllvm
    libxml2
  ];

  cmakeFlags = [
    (lib.cmakeBool "LLVM_BUILD_TOOLS" true)
    # Install headers as well
    (lib.cmakeBool "LLVM_INSTALL_TOOLCHAIN_ONLY" false)
    (lib.cmakeFeature "MLIR_TOOLS_INSTALL_DIR" "${placeholder "out"}/bin/")
    (lib.cmakeBool "LLVM_ENABLE_IDE" false)
    (lib.cmakeFeature "MLIR_INSTALL_PACKAGE_DIR" "${placeholder "dev"}/lib/cmake/mlir")
    (lib.cmakeFeature "MLIR_INSTALL_CMAKE_DIR" "${placeholder "dev"}/lib/cmake/mlir")
    (lib.cmakeBool "LLVM_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "LLVM_ENABLE_FFI" true)
    (lib.cmakeFeature "LLVM_HOST_TRIPLE" stdenv.hostPlatform.config)
    (lib.cmakeFeature "LLVM_DEFAULT_TARGET_TRIPLE" stdenv.hostPlatform.config)
    (lib.cmakeBool "LLVM_ENABLE_DUMP" true)
    (lib.cmakeFeature "LLVM_TABLEGEN_EXE" "${buildLlvmTools.tblgen}/bin/llvm-tblgen")
    (lib.cmakeFeature "MLIR_TABLEGEN_EXE" "${buildLlvmTools.tblgen}/bin/mlir-tblgen")
    (lib.cmakeBool "LLVM_BUILD_LLVM_DYLIB" (!stdenv.hostPlatform.isStatic))
  ]
  ++ lib.optionals stdenv.hostPlatform.isStatic [
    # Disables building of shared libs, -fPIC is still injected by cc-wrapper
    (lib.cmakeBool "LLVM_ENABLE_PIC" false)
    (lib.cmakeBool "LLVM_BUILD_STATIC" true)
    (lib.cmakeBool "LLVM_LINK_LLVM_DYLIB" false)
  ]
  ++ devExtraCmakeFlags;

  outputs = [
    "out"
    "dev"
  ];

  requiredSystemFeatures = [ "big-parallel" ];
  meta = llvm_meta // {
    homepage = "https://mlir.llvm.org/";
    description = "Multi-Level IR Compiler Framework";
    longDescription = ''
      The MLIR project is a novel approach to building reusable and extensible
      compiler infrastructure. MLIR aims to address software fragmentation,
      improve compilation for heterogeneous hardware, significantly reduce
      the cost of building domain specific compilers, and aid in connecting
      existing compilers together.
    '';
  };
})
