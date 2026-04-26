{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cudaPackages,
  replaceVars,
  addDriverRunpath,

  # build-system
  cython,
  pyclibrary,
  setuptools,
  setuptools-scm,

  # env
  symlinkJoin,

  # dependencies
  numpy,

  # tests
  pytestCheckHook,

  # passthru
  cuda-bindings,
}:

buildPythonPackage (finalAttrs: {
  pname = "cuda-bindings";
  version = "12.9.6";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cuda-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uRv27h2b6wXC8oOf5k2KxZ0bUFNvNu6XO05FBbJcU1k=";
  };

  # Apply patch relative to cuda_bindings
  patchFlags = [ "-p2" ];

  patches = [
    (replaceVars ./patch-nvidia-libs-paths.patch {
      libcudart = lib.getLib cudaPackages.cuda_cudart;
      libcufile = lib.getLib cudaPackages.libcufile;
      libnvfatbin = lib.getLib cudaPackages.libnvfatbin;
      libnvjitlink = lib.getLib cudaPackages.libnvjitlink;
      libnvml = addDriverRunpath.driverLink;
      libnvrtc = lib.getLib cudaPackages.cuda_nvrtc;
      libnvvm = "${cudaPackages.cuda_nvcc}/nvvm";
    })
  ];

  sourceRoot = "${finalAttrs.src.name}/cuda_bindings";

  postPatch =
    let
      libCudaPath =
        # Use cuda_compat to provide libcuda.so on pre-Thor Jetsons
        if (cudaPackages.cuda_compat.meta.available or false) then
          cudaPackages.cuda_compat

        # Else, use the host CUDA driver library
        else
          addDriverRunpath.driverLink;
    in
    ''
      substituteInPlace cuda/bindings/_internal/nvjitlink_linux.pyx \
        --replace-fail \
          "handle = dlopen('libcuda.so.1'" \
          "handle = dlopen('${libCudaPath}/lib/libcuda.so.1'"

      substituteInPlace cuda/bindings/_bindings/cydriver.pyx.in \
        --replace-fail \
          "path = 'libcuda.so.1'" \
          "path = '${libCudaPath}/lib/libcuda.so.1'"
    '';

  preBuild = ''
    export CUDA_PYTHON_PARALLEL_LEVEL=$NIX_BUILD_CORES
  '';

  build-system = [
    cython
    pyclibrary
    setuptools
    setuptools-scm
  ];

  env = {
    CUDA_HOME = symlinkJoin {
      name = "cuda-redist";
      paths = with cudaPackages; [
        (lib.getInclude cuda_cudart) # cuda_runtime.h
        (lib.getInclude cuda_nvrtc) # nvrtc.h
        (lib.getInclude cuda_profiler_api) # cudaProfiler.h, cuda_profiler_api.h
      ];
    };
  };

  buildInputs = [
    cudaPackages.cuda_nvcc # crt/host_defines.h
    cudaPackages.libcufile # cufile.h
  ];

  pythonRemoveDeps = [
    # We circumvent cuda_pathfinder to localize nvidia libs with patches
    "cuda-pathfinder"
  ];
  dependencies = [
    # Not explicitly listed as a dependency, but is required at import time
    numpy
  ];

  pythonImportsCheck = [
    "cuda"
    "cuda.bindings.cufile"
    "cuda.bindings.driver"
    "cuda.bindings.nvfatbin"
    "cuda.bindings.nvjitlink"
    "cuda.bindings.nvml"
    "cuda.bindings.nvrtc"
    "cuda.bindings.nvvm"
    "cuda.bindings.runtime"
  ];

  preCheck = ''
    rm -rf cuda
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  enabledTestPaths = [
    "tests/"
  ];

  disabledTestPaths = [
    # The current driver shipped in NixOS (590.48.01) advertises CUDA 13.1, causing the following
    # error:
    # cuda.bindings._internal.utils.NotSupportedError: only CUDA 12 driver is supported
    #
    # Ideally, we should transition to cuda 13 across the whole nixpkgs tree.
    "tests/test_nvjitlink.py"
  ];

  disabledTests = [
    # sysfs cpu topology is not available in the sandbox, causing:
    #   cuda.bindings.nvml.UnknownError: Unknown Error
    #   hwloc/linux: failed to find sysfs cpu topology directory, aborting linux discovery.
    "test_device_get_cpu_affinity_within_scope"
    "test_device_get_memory_affinity"

    # Requires the nvidia_fs kernel module (GPUDirect Storage), causing:
    #   cuda.bindings.cufile.cuFileError: NVFS_SETUP_ERROR (5033): NVFS driver initialization error
    "test_buf_register_already_registered"
    "test_buf_register_host_memory"
    "test_buf_register_invalid_flags"
    "test_buf_register_large_buffer"
    "test_buf_register_multiple_buffers"
    "test_buf_register_simple"
    "test_driver_open"
  ];

  # Tests need access to a GPU
  doCheck = false;
  passthru.gpuCheck = cuda-bindings.overridePythonAttrs {
    requiredSystemFeatures = [ "cuda" ];
    doCheck = true;
  };

  meta = {
    description = "Standard set of low-level interfaces, providing access to the CUDA host APIs from Python";
    homepage = "https://github.com/NVIDIA/cuda-python/tree/main/cuda_bindings";
    changelog = "https://nvidia.github.io/cuda-python/${finalAttrs.version}/release/${finalAttrs.version}-notes.html";
    license = lib.licenses.unfreeRedistributable; # NVIDIA Proprietary Software
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
