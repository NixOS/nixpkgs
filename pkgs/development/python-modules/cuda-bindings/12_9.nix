{
  replaceVars,
  cudaLibPaths,
}:
{
  version = "12.9.6";
  sourceHash = "sha256-uRv27h2b6wXC8oOf5k2KxZ0bUFNvNu6XO05FBbJcU1k=";

  nvidiaLibsPatch = replaceVars ./patch-nvidia-libs-paths_12_9.patch {
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
}
