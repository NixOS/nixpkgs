{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  symlinkJoin,

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

    # DeepGEMM does JIT compilation and needs to access the NVIDIA compiler and some libraries at
    # runtime.
    # Instead of letting it search for the cuda toolkit on the host, hardcode the path to a custom
    # closure.
    (replaceVars ./patch-runtime-cuda-home-path.patch {
      cuda_home = symlinkJoin {
        name = "cuda-toolkit";
        paths = with cudaPackages; [
          (lib.getBin cuda_nvcc) # bin/nvcc, bin/ptxas, nvvm/, nvcc.profile
          (lib.getBin cutlass) # include/cute, include/cutlass
          (lib.getInclude cccl) # include/cuda/std/* (libcu++)
          (lib.getInclude cuda_cudart) # include/cuda_runtime.h, cuda_bf16.h, cuda_fp8.h
          (lib.getInclude cuda_cuobjdump) # bin/cuobjdump
        ];
      };
    })
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
