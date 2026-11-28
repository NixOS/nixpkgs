{
  lib,
  config,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cudaPackages,
  cython,
  setuptools,
  tomli,

  # dependencies
  cuda-bindings,
  cuda-core,
  cuda-pathfinder,
  numpy,

  cudaSupport ? config.cudaSupport,
}:

buildPythonPackage.override { stdenv = cudaPackages.backendStdenv; } (finalAttrs: {
  pname = "nvmath-python";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvmath-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RpgEX6IFBw35TED3mb8ibLc0o15ciMNwX+LuIrlClqg=";
  };

  postPatch = ''
    # FIX:
    # > ERROR Unmet dependencies (checked against /nix/store/XXX-python3-3.14.6/bin/python3.14):
    # >       cuda-toolkit[cudart,nvcc]<14,>=13.1
    # >             wanted: <14,>=13.1
    # >              found: not installed
    sed -i '/cuda-toolkit/d' pyproject.toml
  '';

  build-system = [
    cython
    setuptools
    tomli
  ];

  dependencies = [
    cuda-bindings
    cuda-core
    cuda-pathfinder
    numpy
  ];

  nativeBuildInputs = [
    cudaPackages.cuda_nvcc
  ];

  buildInputs = [
    cudaPackages.cuda_cudart
  ];

  pythonImportsCheck = [
    "nvmath"
  ];

  meta = {
    description = "NVIDIA Math Libraries for the Python Ecosystem";
    homepage = "https://pypi.org/project/nvmath-python";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [
      cuda
      ngi
    ];
    broken = !cudaSupport || cudaPackages.cudaOlder "13.1" || cudaPackages.cudaAtLeast "14";
  };
})
