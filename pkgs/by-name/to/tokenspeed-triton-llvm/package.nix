{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  python3,

  llvmTargetsToBuild ? [ "NATIVE" ], # "NATIVE" resolves into x86 or aarch64 depending on stdenv
  llvmProjectsToBuild ? [
    # Required for building triton>=3.7.0
    # https://github.com/triton-lang/triton/blob/a34f373ba47899831f3de3c83cd8f4877bf23d69/third_party/nvidia/CMakeLists.txt#L14
    "clang"

    # Required for building triton>=3.5.0
    # https://github.com/triton-lang/triton/blob/c3c476f357f1e9768ea4e45aa5c17528449ab9ef/third_party/amd/CMakeLists.txt#L6
    "lld"

    "llvm"
    "mlir"
  ],
}:
let
  llvmNativeTarget =
    if stdenv.hostPlatform.isx86_64 then
      "X86"
    else if stdenv.hostPlatform.isAarch64 then
      "AArch64"
    else
      throw "Currently unsupported LLVM platform '${stdenv.hostPlatform.config}'";

  inferNativeTarget = t: if t == "NATIVE" then llvmNativeTarget else t;
  llvmTargetsToBuild' = [
    "AMDGPU"
    "NVPTX"
  ]
  ++ map inferNativeTarget llvmTargetsToBuild;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "tokenspeed-triton-llvm";
  version = "24.0.0-unstable-2026-08-03"; # See cmake/Modules/LLVMVersion.cmake
  __structuredAttrs = true;
  strictDeps = true;

  # See https://github.com/lightseekorg/triton/blob/v3.8.10.post20260920/cmake/llvm-info.json
  src = fetchFromGitHub {
    owner = "llvm";
    repo = "llvm-project";
    rev = "b010a18d2b648cab83c83967ff26b8fde11acdc6";
    hash = "sha256-stgOKrTcZo6eq/oOkIRo89t/lIJ2ADFzh7XHuNdxeJs=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ];

  preConfigure = ''
    cd llvm
  '';

  cmakeFlags = [
    (lib.cmakeFeature "LLVM_TARGETS_TO_BUILD" (lib.concatStringsSep ";" llvmTargetsToBuild'))
    (lib.cmakeFeature "LLVM_ENABLE_PROJECTS" (lib.concatStringsSep ";" llvmProjectsToBuild))
    (lib.cmakeBool "LLVM_INSTALL_UTILS" true)
  ];

  requiredSystemFeatures = [ "big-parallel" ];

  meta = {
    description = "Collection of modular and reusable compiler and toolchain technologies";
    homepage = "https://github.com/llvm/llvm-project";
    license =
      with lib.licenses;
      AND [
        ncsa
        (WITH asl20 llvm-exception)
      ];
    maintainers = with lib.maintainers; [ prince213 ];
    platforms = with lib.platforms; aarch64 ++ x86;
  };
})
