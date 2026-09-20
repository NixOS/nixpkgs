{
  lib,
  config,
  buildPythonPackage,
  fetchFromGitHub,
  cudaPackages,
  replaceVars,

  # build-system
  cmake,
  cython,
  ninja,
  scikit-build-core,
  setuptools-scm,

  # dependencies
  cuda-bindings,
  cuda-core,
  cuda-pathfinder,
  numpy,
  typing-extensions,

  # tests
  cupy,
  pytestCheckHook,

  # passthru
  nix-update-script,
}:

buildPythonPackage.override { stdenv = cudaPackages.backendStdenv; } (finalAttrs: {
  pname = "cuda-cccl";
  version = "1.2.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cccl";
    tag = "python-${finalAttrs.version}";
    hash = "sha256-0Qsf3l9VvSxYVVWQG0ST7S33s7LdsNyWoV6Q2f0Ru6o=";
  };

  sourceRoot = "${finalAttrs.src.name}/python/cuda_cccl";

  patches = [
    (replaceVars ./patch-nvidia-libs-paths.patch {
      libcudart = lib.getLib cudaPackages.cuda_cudart;
      libnvjitlink = lib.getLib cudaPackages.libnvjitlink;
      libnvrtc = lib.getLib cudaPackages.cuda_nvrtc;
    })

    # Disable all tests requiring unpackaged `numba-cuda-mlir` through `cuda.compute`
    ./skip-missing-jit-backend.patch
  ];
  # Apply patch relative to python/cuda_cccl
  patchFlags = [ "-p3" ];

  postPatch = ''
    substituteInPlace cuda/cccl/headers/include_paths.py \
      --replace-fail \
        'find_nvidia_header_directory("cudart")' \
        '"${lib.getInclude cudaPackages.cuda_cudart}/include"'
  '';

  build-system = [
    cmake
    cython
    ninja
    scikit-build-core
    setuptools-scm
  ];
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cudaPackages.cuda_nvcc
  ];

  buildInputs = with cudaPackages; [
    cuda_cudart # cuda_runtime.h
    cuda_nvrtc # nvrtc.h
    libnvjitlink
  ];

  dependencies = [
    cuda-bindings
    cuda-core
    cuda-pathfinder
    numpy
    typing-extensions
  ];

  pythonImportsCheck = [
    "cuda.cccl"
    "cuda.compute"
  ];

  nativeCheckInputs = [
    cupy
    pytestCheckHook
  ];

  preCheck = ''
    rm -rf cuda
  ''
  # Otherwise, cupy will try to write in $HOME (/homeless-shelter)
  + ''
    export CUPY_CACHE_DIR=$(mktemp -d)
  '';

  disabledTests = [
    # Sorts 2**28 elements, which does not fit in the test runner's memory pool
    #   RuntimeError: Failed to allocate memory from pool
    "test_radix_sort_large_num_items"
  ];

  disabledTestPaths = [
    # Require the unpackaged `numba-cuda-mlir` JIT backend
    #   ModuleNotFoundError: No module named 'numba_cuda_mlir'
    "tests/compute/test_jit_backend.py"
    "tests/compute/test_void_ptr_wrapper_validation.py"
  ];

  # Tests require access to a GPU
  doCheck = false;
  passthru = {
    gpuCheck = finalAttrs.finalPackage.overrideAttrs {
      requiredSystemFeatures = [ "cuda" ];
      doInstallCheck = true;
    };

    updateScript = nix-update-script {
      extraArgs = [ "--version-regex=python-(.*)" ];
    };
  };

  meta = {
    description = "CUDA Core Compute Libraries for Python";
    homepage = "https://github.com/NVIDIA/cccl/tree/main/python/cuda_cccl";
    changelog = "https://github.com/NVIDIA/cccl/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    teams = [ lib.teams.cuda ];
    maintainers = with lib.maintainers; [ GaetanLepage ];
    broken = !config.cudaSupport;
  };
})
