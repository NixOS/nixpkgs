{
  replaceVars,
  cudaLibPaths,
}:
{
  version = "13.2.0";
  sourceHash = "sha256-VOaRjZwg1phGjkOeXjWMcs/vjlPMNKiVSKyKrQG5ohM=";

  nvidiaLibsPatch = replaceVars ./patch-nvidia-libs-paths_13_2.patch {
    inherit (cudaLibPaths)
      libcudart
      libcufile
      libnvfatbin
      libnvjitlink
      libnvml
      libnvrtc
      libnvvm
      ;
  };

  pythonImportsCheck = [
    "cuda.bindings.nvfatbin"
    "cuda.bindings.nvml"
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
