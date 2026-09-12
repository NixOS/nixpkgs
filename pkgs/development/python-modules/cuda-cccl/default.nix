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
  numba,
  pytestCheckHook,

  # passthru
  nix-update-script,
}:

buildPythonPackage.override { stdenv = cudaPackages.backendStdenv; } (finalAttrs: {
  pname = "cuda-cccl";
  version = "1.1.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cccl";
    tag = "python-${finalAttrs.version}";
    hash = "sha256-El6Hu7AtjiML+ID5yox+RCR/cwTufM9pvqJI5OsuQsU=";
  };

  sourceRoot = "${finalAttrs.src.name}/python/cuda_cccl";

  patches = [
    (replaceVars ./patch-nvidia-libs-paths.patch {
      libnvjitlink = lib.getLib cudaPackages.libnvjitlink;
      libnvrtc = lib.getLib cudaPackages.cuda_nvrtc;
    })
  ];
  # Apply patch relative to python/cuda_cccl
  patchFlags = [ "-p3" ];

  postPatch = ''
    substituteInPlace cuda/cccl/headers/include_paths.py \
      --replace-fail \
        'find_nvidia_header_directory("cudart")' \
        '"${lib.getInclude cudaPackages.cuda_cudart}/include"' \
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
    "cuda.compute"
    "cuda.coop"
  ];

  nativeCheckInputs = [
    cupy
    numba
    pytestCheckHook
  ];

  preCheck = ''
    rm -rf cuda
  ''
  # Otherwise, cupy will try to write in $HOME (/homeless-shelter)
  + ''
    export CUPY_CACHE_DIR=$(mktemp -d)
  '';

  disabledTestPaths = [
    # `cuda.coop` compiles device functions to LTO-IR and links them via `numba.cuda`, which is
    # provided by unpackaged numba-cuda.
    # numba's own linker cannot consume `.ltoir`:
    #   RuntimeError: Don't know how to link file with extension .ltoir
    "tests/coop"
  ];

  disabledTests = [
    # Use `numba.cuda.np.arrayobj`, only provided by unpackaged numba-cuda
    #   ModuleNotFoundError: No module named 'numba.cuda.np'
    "test_select_stateful_atomic"
    "test_select_stateful_same_bytecode_different_state"
    "test_select_stateful_state_updates"
    "test_select_stateful_threshold"
    "test_select_with_side_effect_counting_rejects"
    "test_stateful_caching_same_dtype_different_values"
    "test_stateful_transform_same_bytecode_different_sizes"
    "test_unary_transform_stateful_closure_factory"
    "test_unary_transform_stateful_counting"
    "test_unary_transform_stateful_multiple_arrays"
    "test_unary_transform_stateful_state_updates"

    # Use `numba.cuda.compiler._compile_pyfunc_with_fixup`, only provided by unpackaged numba-cuda
    #   TypeError: Signature mismatch: 2 argument types given, but function takes 1
    "test_exclusive_scan_max"
    "test_reduce_struct_type_minmax"
    "test_zip_iterator_with_scan"

    # Examples exercising the two paths above, as well as the LTO-IR linking of `tests/coop`
    "test_compute_examples_reduction_minmax_reduction"
    "test_compute_examples_scan_exclusive_scan_max"
    "test_compute_examples_scan_logcdf_example"
    "test_compute_examples_select_select_with_side_effect"
    "test_coop__experimental_examples_block_reduce"
    "test_coop__experimental_examples_block_scan"
    "test_coop__experimental_examples_warp_reduce"
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
