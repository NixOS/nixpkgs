{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  ninja,
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
  expecttest,
  onnxscript,
  pytestCheckHook,
  torchvision,

  apex,

  cudaPackages,
  cudaSupport ? torch.cudaSupport,
}:

buildPythonPackage.override { inherit (torch) stdenv; } (finalAttrs: {
  pname = "apex";
  version = "26.09";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nvidia";
    repo = "apex";
    tag = finalAttrs.version;
    hash = "sha256-JGyPm25GuKYYv04yUYCeBg73rPdd7kmVRiIR8PU4n5s=";
  };

  postPatch =
    # Fix incompatibility with more recent versions of cudnn-frontend to de-vendor it:
    #   error: ‘throw_if’ is not a member of ‘cudnn_frontend’
    ''
      substituteInPlace \
        apex/contrib/csrc/bottleneck/bottleneck.cpp \
        apex/contrib/csrc/conv_bias_relu/conv_bias_relu.cpp \
        apex/contrib/csrc/cudnn_gbn/norm_sample.cpp \
        --replace-fail \
          'cudnn_frontend::throw_if([status]() { return (status != CUDNN_STATUS_SUCCESS); }, "Plan execute error", status);' \
          'if (status != CUDNN_STATUS_SUCCESS) { throw cudnn_frontend::cudnnException("Plan execute error", status); }'
    ''
    # Don't fetch the cudnn-frontend git submodule (cudnn-frontend comes from buildInputs): its only uses of git are
    # `subprocess.run(["git", "submodule", "update", "--init", "apex/contrib/csrc/cudnn-frontend/"])`, which would
    # raise FileNotFoundError without git. Run `true` instead.
    + ''
      substituteInPlace setup.py \
        --replace-fail \
          '"git",' \
          '"true",'
    ''
    # Upstream hardcodes `version="0.1"` in setup.py, which fails the metadata check
    + ''
      substituteInPlace setup.py \
        --replace-fail \
          'version="0.1",' \
          'version="${finalAttrs.version}",'
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
    # https://github.com/NVIDIA/apex/tree/26.09#custom-ccuda-extensions-and-install-options
    APEX_ALL_CONTRIB_EXT = 1;
  };

  # Keep the number of concurrent compiler processes within NIX_BUILD_CORES. Parallelism multiplies across two levels:
  # setup.py builds APEX_PARALLEL_BUILD extensions at once (a build_ext thread pool), and torch's cpp_extension builds
  # each extension with ninja, running MAX_JOBS jobs (when unset, ninja's default: every CPU of the machine). Each job
  # (cc1plus, cicc, cudafe++) can take ~2 GB, so APEX_PARALLEL_BUILD=$NIX_BUILD_CORES without MAX_JOBS ran
  # cores x CPUs jobs and exhausted the builder's memory. Most extensions have only a few sources, so favour building
  # extensions in parallel, with two ninja jobs each. nvcc's --threads is not used, as it would multiply this again.
  preBuild = ''
    export MAX_JOBS=2
    export APEX_PARALLEL_BUILD=$(( NIX_BUILD_CORES > 2 ? NIX_BUILD_CORES / 2 : 1 ))
  '';

  build-system = [
    ninja
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
      libcublas # cublas_v2.h
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
    "_apex_nccl_allocator"
    "amp_C"
    "apex_C"
    "bnp"
    "fused_layer_norm_cuda"
    "nccl_p2p_cuda"
    "syncbn"
  ];

  nativeCheckInputs = [
    expecttest # torch.testing._internal.common_utils
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
