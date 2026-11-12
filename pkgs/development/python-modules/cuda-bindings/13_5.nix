{
  replaceVars,
  cudaLibPaths,
}:
{
  version = "13.5.0";
  # The CUDA 13 bindings moved to their own source root in 13.5
  # https://github.com/NVIDIA/cuda-python/pull/3147
  sourceDir = "cuda_bindings_13";
  sourceHash = "sha256-9cQS4WFXkR4BynrfdPaeG3+oFd4DPMJt3E+zPyTixJQ=";

  nvidiaLibsPatch = replaceVars ./patch-nvidia-libs-paths_13_5.patch {
    inherit (cudaLibPaths)
      libcuda
      libcudart
      libcudla
      libcufile
      libnvfatbin
      libnvjitlink
      libnvml
      libnvrtc
      libnvvm
      ;
  };

  # Remove cuda-pathfinder from build-system requirements
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        '"cuda-pathfinder>=1.5",' \
        ""
  '';

  pythonImportsCheck = [
    "cuda.bindings.cudla"
    "cuda.bindings.nvfatbin"
    "cuda.bindings.nvml"
  ];

  disabledTestPaths = [
    # Tests the build backend from the source tree, which preCheck removes, causing:
    #   FileNotFoundError: [Errno 2] No such file or directory: '.../cuda/bindings/cydriver.pxd'
    # Its Cython cache tests also fail in the sandbox (AssertionError: warm run should hit cache)
    "tests/test_build_hooks.py"
  ];

  disabledTests = [
    # Requires GPU discovery support not available in the test environment
    "test_discover_gpus"

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
    "test_get_bar_size_in_kb"
    "test_get_parameter_min_max_value"
    "test_set_parameter_posix_pool_slab_array"
    "test_set_stats_level"
    "test_stats_start_stop"
  ];
}
