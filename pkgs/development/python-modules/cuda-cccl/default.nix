{
  lib,
  config,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
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
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cccl";
    tag = "python-${finalAttrs.version}";
    hash = "sha256-GyZD6YGqZNS3HDuhv0Y286LtisqqxHLr8SlGee5rXlw=";
  };

  sourceRoot = "${finalAttrs.src.name}/python/cuda_cccl";
  # Some patches touch files outside of sourceRoot
  postUnpack = ''
    chmod -R u+w -- "$sourceRoot/../.."
  '';

  patches = [
    (replaceVars ./patch-nvidia-libs-paths.patch {
      libcudart = lib.getLib cudaPackages.cuda_cudart;
      libnvjitlink = lib.getLib cudaPackages.libnvjitlink;
      libnvrtc = lib.getLib cudaPackages.cuda_nvrtc;
    })

    # Disable all tests requiring unpackaged `numba-cuda-mlir` through `cuda.compute`
    ./skip-missing-jit-backend.patch

    # Fix build with CUDA >= 13.4
    # https://github.com/NVIDIA/cccl/pull/11823
    (fetchpatch {
      name = "c-parallel-allow-cuda-13_4.patch";
      url = "https://github.com/NVIDIA/cccl/commit/1504f9d7a6a8b15679c36df2f1ee11a413fdedc8.patch";
      hash = "sha256-OPwoxwshkw+h4pD60/eCxUi8O1WM2WhNSchxkGdagU4=";
    })
  ];
  # Apply patches from the repository root (parent of sourceRoot)
  patchFlags = [
    "-p1"
    "-d"
    "../.."
  ];

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
