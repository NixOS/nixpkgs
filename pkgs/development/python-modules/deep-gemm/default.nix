{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  torch,

  # buildInputs
  fmt,
  pybind11,

  # nativeBuildInputs
  autoAddDriverRunpath,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,

  # passthru
  deep-gemm,

  config,
  cudaPackages,
  cudaSupport ? config.cudaSupport,
}:

let
  inherit (lib)
    getBin
    optionalAttrs
    optionals
    ;
in
buildPythonPackage.override { inherit (torch) stdenv; } (finalAttrs: {
  pname = "deep-gemm";
  version = "2.1.1.post3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deepseek-ai";
    repo = "DeepGEMM";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2yEHiuTaNUodWlZk7waqBsVMip2qiVJPgQHwsY0I63k=";
  };

  patches = [
    ./use-system-libraries.patch
  ];

  env = optionalAttrs cudaSupport {
    CUDA_HOME = (getBin cudaPackages.cuda_nvcc).outPath;

    LDFLAGS = toString [
      # Fake libcuda.so (the real one is deployed impurely)
      "-L${lib.getOutput "stubs" cudaPackages.cuda_cudart}/lib/stubs"
    ];
  };

  build-system = [
    setuptools
    torch
  ];

  nativeBuildInputs = [
    autoAddDriverRunpath
  ];

  buildInputs = [
    fmt
    pybind11
  ]
  ++ optionals cudaSupport (
    with cudaPackages;
    [
      cuda_cudart # cuda_runtime_api.h
      cuda_nvrtc # nvrtc.h
      cutlass # cute/arch/mma_sm100_desc.hpp
      libcublas # cublas_v2.h
      libcusolver # cusolverDn.h
      libcusparse # cusparse.h
    ]
  );

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  # Tests require GPU access
  doCheck = false;

  passthru.gpuCheck = deep-gemm.overridePythonAttrs {
    requiredSystemFeatures = [ "cuda" ];

    # dlopens libcuda.so at import time
    pythonImportsCheck = [ "deep_gemm" ];

    doCheck = true;
  };

  meta = {
    description = "Clean and efficient FP8 GEMM kernels with fine-grained scaling";
    homepage = "https://github.com/deepseek-ai/DeepGEMM";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    broken = !cudaSupport;
  };
})
