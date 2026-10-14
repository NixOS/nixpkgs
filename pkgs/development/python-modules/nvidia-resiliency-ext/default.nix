{
  lib,
  config,
  buildPythonPackage,
  cudaPackages,
  fetchFromGitHub,

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
  pyyaml,
  slowapi,
  torch,
  uvicorn,

  # optional-dependencies
  mcp,
  setproctitle,
  slack-bolt,
  slack-sdk,

  # tests
  pytestCheckHook,

  cudaSupport ? config.cudaSupport,
}:

buildPythonPackage.override { stdenv = cudaPackages.backendStdenv; } (finalAttrs: {
  pname = "nvidia-resiliency-ext";
  version = "0.7.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvidia-resiliency-ext";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sQcmZP6oPVf6uty+M7FNJi8nhqY/r2HFAH787jzRwik=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        "grpcio-tools>=1.76.0,<1.77.0" \
        "grpcio-tools"
  '';

  build-system = [
    grpcio-tools
    poetry-core
    poetry-dynamic-versioning
    pybind11
    setuptools
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
    pyyaml
    slowapi
    torch
    uvicorn
  ];

  optional-dependencies = {
    attribution = [
      mcp
      setproctitle
      slack-bolt
      slack-sdk
    ];
  };

  pythonImportsCheck = [ "nvidia_resiliency_ext" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

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
