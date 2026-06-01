{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  typing-extensions,

  # nativeBuildInputs
  cmake,
  cudaPackages,

  # buildInputs
  dlpack,

  # nativeCheckInputs
  pytestCheckHook,
  torch,
}:
let
  # https://github.com/NVIDIA/cutile-python/blob/v1.4.0/cmake/FetchXLAHeaders.cmake#L5-L6
  xla = fetchFromGitHub {
    owner = "openxla";
    repo = "xla";
    rev = "b6f37ab7767f428fd6f993de5e211643d47d4deb";
    hash = "sha256-U4e3k4nm9gB1x5hahXwycWSryBQuxIPmOzVf6kuahY0=";
  };
in
buildPythonPackage (finalAttrs: {
  pname = "cuda-tile";
  version = "1.4.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cutile-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R5V69nJLQ3/1995ezH1/WuueA6cm1vhKZdOECqbwPbU=";
  };

  patches = [
    ./link-libc.patch
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools==80.10.2"' '"setuptools"'

    rm cmake/FindCUDAToolkit.cmake
    echo "${finalAttrs.version}" >src/cuda/tile/VERSION
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    typing-extensions
  ];

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
    cudaPackages.cuda_nvcc
  ];

  buildInputs = [
    cudaPackages.cuda_cudart # cuda.h
  ];

  pythonImportsCheck = [ "cuda.tile" ];

  # libcuda.so.1
  doCheck = false;
  nativeCheckInputs = [
    pytestCheckHook
    torch
  ];

  env = {
    CUDA_TILE_CMAKE_DLPACK_PATH = dlpack;
    CUDA_TILE_CMAKE_XLA_PATH = xla;
  };

  passthru.gpuCheck = finalAttrs.finalPackage.overrideAttrs {
    requiredSystemFeatures = [ "cuda" ];
    doCheck = true;
  };

  meta = {
    description = "CUDA Tile Compiler";
    homepage = "https://docs.nvidia.com/cuda/cutile-python/";
    downloadPage = "https://github.com/NVIDIA/cutile-python/tags";
    changelog = "https://docs.nvidia.com/cuda/cutile-python/generated/release_notes.html";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ prince213 ];
  };
})
