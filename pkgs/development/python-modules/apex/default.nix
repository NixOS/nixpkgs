{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  torch,

  # buildInputs
  pybind11,

  # nativeBuildInputs
  writableTmpDirAsHomeHook,

  # dependencies
  cxxfilt,
  numpy,
  packaging,
  pytest,
  pyyaml,
  tqdm,

  # tests
  onnxscript,
  pytestCheckHook,
  torchvision,

  apex,

  cudaPackages,
  cudaSupport ? torch.cudaSupport,
}:

buildPythonPackage.override { inherit (torch) stdenv; } (finalAttrs: {
  pname = "apex";
  version = "25.09";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nvidia";
    repo = "apex";
    tag = finalAttrs.version;
    hash = "sha256-/WcFCDjNXWbCnWoprYYAUcLt9p1CqJLzPXcBkPn+ics=";
  };

  patches = [
    # Fix incompatibility with more recent versions of cudnn to de-vendor it:
    #   error: ‘throw_if’ is not a member of ‘cudnn_frontend’
    ./fix-cudnn-frontend-compat.patch
  ];

  # Don't use git submodules for cuda dependencies
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail \
        'subprocess.run(["git", "submodule", "update", "--init", "apex/contrib/csrc/multihead_attn/cutlass"])' \
        "" \
      --replace-fail \
        'subprocess.run(["git", "submodule", "update", "--init", "apex/contrib/csrc/cudnn-frontend/"])' \
        ""
  '';

  env = {
    APEX_CPP_EXT = 1;
  }
  // lib.optionalAttrs cudaSupport {
    CUDA_HOME = (lib.getBin cudaPackages.cuda_nvcc).outPath;
    TORCH_CUDA_ARCH_LIST = "${lib.concatStringsSep ";" torch.cudaCapabilities}";

    # Even if APEX_ALL_CONTRIB_EXT is enabled, APEX_CUDA_EXT must be explicitly enable
    APEX_CUDA_EXT = 1;

    # Enable all contrib extensions at once
    # https://github.com/NVIDIA/apex/tree/25.09#custom-ccuda-extensions-and-install-options
    APEX_ALL_CONTRIB_EXT = 1;

    NVCC_APPEND_FLAGS = lib.toString [
      # Make kernel compilation slightly more parallel
      "--threads 2"
    ];
  };

  preBuild = ''
    export APEX_PARALLEL_BUILD=$NIX_BUILD_CORES
  '';

  build-system = [
    setuptools
    torch
  ];

  buildInputs = [
    pybind11
  ]
  ++ lib.optionals cudaSupport (
    with cudaPackages;
    [
      cuda_cudart # cuda_runtime.h
      cuda_profiler_api # cuda_profiler_api.h
      cudnn # cudnn.h
      cudnn-frontend # cudnn_frontend.h
      cutlass # cutlass/cutlass.h
      libcublas # cublas_v2.h
      libcufile # cufile.h
      libcurand # curand_kernel.h
      libcusolver # cusolverDn.h
      libcusparse # cusparse.h
      nccl # nccl.h
    ]
  );

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
  ];

  dependencies = [
    cxxfilt
    numpy
    packaging
    pytest
    pyyaml
    tqdm
  ];

  pythonImportsCheck = [
    "apex"
    "apex_C"
  ]
  ++ lib.optionals cudaSupport [
    "_apex_gpu_direct_storage"
    "_apex_nccl_allocator"
    "amp_C"
    "apex_C"
    "bnp"
    "fmhalib"
    "fused_layer_norm_cuda"
    "nccl_p2p_cuda"
    "syncbn"
  ];

  nativeCheckInputs = [
    onnxscript
    pytestCheckHook
    torchvision
  ];
  preCheck = ''
    rm -rf apex
  ''
  # Otherwise, test collection fails with:
  #   ModuleNotFoundError: No module named 'test_fused_optimizer'
  + ''
    rm tests/L0/run_optimizers/__init__.py
  '';
  doCheck = false;
  disabledTestPaths = [
    # Try to read the driver version from nvidia-smi (failing in the sandbox)
    #   TypeError: expected string or bytes-like object, got 'NoneType'
    "tests/L0/run_transformer/"

    # apex.parallel was removed in https://github.com/NVIDIA/apex/pull/1896, but some tests still
    # try to import it
    "tests/distributed/DDP/ddp_race_condition_test.py"
    "tests/distributed/synced_batchnorm/"
  ];

  disabledTests = [
    # RuntimeError: The tensor has a non-zero number of elements, but its data is not allocated yet.
    # torch.onnx._internal.exporter._errors.TorchExportError: Failed to export the model with torch.export.
    "test_layer_norm_export_cuda"
    "test_rms_export_cuda"
  ];

  passthru.gpuCheck = apex.overridePythonAttrs {
    requiredSystemFeatures = [ "cuda" ];
    doCheck = true;
  };

  meta = {
    description = "Tools for easy mixed precision and distributed training in Pytorch";
    homepage = "https://github.com/nvidia/apex";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    broken = !cudaSupport;
  };
})
