{
  lib,
  config,
  buildPythonPackage,
  cudaPackages,
  fetchFromGitHub,
  bash,
  symlinkJoin,

  # build-system
  grpcio-tools,
  poetry-core,
  poetry-dynamic-versioning,
  pybind11,
  setuptools,

  # dependencies
  defusedxml,
  fastapi,
  grpcio,
  httpx,
  numpy,
  nvidia-ml-py,
  packaging,
  protobuf,
  psutil,
  pydantic,
  pydantic-settings,
  slack-sdk,
  slowapi,
  torch,
  typing-extensions,
  uvicorn,

  # optional-dependencies
  mcp,
  pyjwt,
  setproctitle,
  slack-bolt,

  # tests
  addBinToPathHook,
  hypothesis,
  pytestCheckHook,

  cudaSupport ? config.cudaSupport,
}:

buildPythonPackage.override { stdenv = cudaPackages.backendStdenv; } (finalAttrs: {
  pname = "nvidia-resiliency-ext";
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvidia-resiliency-ext";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VUp2KWPKPAl12mF4VZUmeV/aRCy+Dypy6NqeWLLfABA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        "grpcio-tools>=1.76.0,<1.77.0" \
        "grpcio-tools"
  ''
  # FileNotFoundError: [Errno 2] No such file or directory: '/bin/bash'
  + ''
    substituteInPlace tests/fault_tolerance/unit/test_scheduler_segment_health.py \
      --replace-fail "/bin/bash" "${lib.getExe bash}" \
      --replace-fail "/bin/sleep" "sleep"
  '';

  build-system = [
    grpcio-tools
    poetry-core
    poetry-dynamic-versioning
    pybind11
    setuptools
  ];

  # build.py looks for cupti.h and libcupti.so under $CUDA_PATH to build the CUPTI extension
  env.CUDA_PATH = symlinkJoin {
    name = "cuda-cupti-joined";
    paths = with cudaPackages; [
      (lib.getInclude cuda_cupti)
      (lib.getLib cuda_cupti)
    ];
  };

  buildInputs = with cudaPackages; [
    cuda_cudart # cuda_runtime_api.h
    cuda_cupti
  ];

  dependencies = [
    defusedxml
    fastapi
    grpcio
    grpcio-tools
    httpx
    numpy
    nvidia-ml-py
    packaging
    protobuf
    psutil
    pydantic
    pydantic-settings
    slack-sdk
    slowapi
    torch
    typing-extensions
    uvicorn
  ];

  optional-dependencies = {
    attribution = [
      mcp
      pyjwt
      setproctitle
      slack-bolt
    ]
    ++ pyjwt.optional-dependencies.crypto;
  };

  pythonImportsCheck = [ "nvidia_resiliency_ext" ];

  nativeCheckInputs = [
    # Tests invoke `ft_launcher`
    addBinToPathHook
    hypothesis
    pytestCheckHook
  ];

  # Most of the test suite requires GPUs and/or a distributed setup
  enabledTestPaths = [
    "tests/checkpointing/unit_cpu"
    "tests/fault_tolerance/unit"
    "tests/shared_utils"
  ];

  passthru.gpuCheck = finalAttrs.finalPackage.overrideAttrs {
    requiredSystemFeatures = [ "cuda" ];
    enabledTestPaths = [
      "tests/straggler/unit"
    ];
  };

  meta = {
    description = "Python package for framework developers and users to implement fault-tolerant features";
    homepage = "https://github.com/NVIDIA/nvidia-resiliency-ext";
    changelog = "https://github.com/NVIDIA/nvidia-resiliency-ext/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    teams = [ lib.teams.cuda ];
    broken = !cudaSupport;
  };
})
