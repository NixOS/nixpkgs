{ lib, stdenv, llvm_meta
, buildLlvmTools
, monorepoSrc, runCommand
, cmake
, ninja
, libxml2
, libllvm
, version
, doCheck ? (!stdenv.isx86_32 /* TODO: why */) && (!stdenv.hostPlatform.isMusl)
}:

stdenv.mkDerivation rec {
  pname = "mlir";
  inherit version doCheck;

  # Blank llvm dir just so relative path works
  src = runCommand "${pname}-src-${version}" {} ''
    mkdir -p "$out"
    cp -r ${monorepoSrc}/cmake "$out"
    cp -r ${monorepoSrc}/${pname} "$out"
    cp -r ${monorepoSrc}/third-party "$out/third-party"

    mkdir -p "$out/llvm"
  '';

  sourceRoot = "${src.name}/${pname}";

  patches = [
    ./gnu-install-dirs.patch
  ];

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ libllvm libxml2 ];

  ninjaFlags = [ "-v " ];
  cmakeFlags = [
    "-DLLVM_BUILD_TOOLS=ON"
    # Install headers as well
    "-DLLVM_INSTALL_TOOLCHAIN_ONLY=OFF"
    "-DMLIR_TOOLS_INSTALL_DIR=${placeholder "out"}/bin/"
    "-DLLVM_ENABLE_IDE=OFF"
    "-DLLD_INSTALL_PACKAGE_DIR=${placeholder "out"}/lib/cmake/mlir"
    "-DLLVM_BUILD_TESTS=${if doCheck then "ON" else "OFF"}"
    "-DLLVM_ENABLE_FFI=ON"
    "-DLLVM_HOST_TRIPLE=${stdenv.hostPlatform.config}"
    "-DLLVM_DEFAULT_TARGET_TRIPLE=${stdenv.hostPlatform.config}"
    "-DLLVM_ENABLE_DUMP=ON"
  ]  ++ lib.optionals stdenv.hostPlatform.isStatic [
    # Disables building of shared libs, -fPIC is still injected by cc-wrapper
    "-DLLVM_ENABLE_PIC=OFF"
    "-DLLVM_BUILD_STATIC=ON"
    "-DLLVM_LINK_LLVM_DYLIB=off"
  ] ++ lib.optionals ((stdenv.hostPlatform != stdenv.buildPlatform) && !(stdenv.buildPlatform.canExecute stdenv.hostPlatform)) [
    "-DLLVM_TABLEGEN_EXE=${buildLlvmTools.llvm}/bin/llvm-tblgen"
    "-DMLIR_TABLEGEN_EXE=${buildLlvmTools.mlir}/bin/mlir-tblgen"
  ];

  outputs = [ "out" "dev" ];

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
}
