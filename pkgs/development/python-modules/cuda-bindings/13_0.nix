{
  replaceVars,
  cudaLibPaths,
}:
{
  version = "13.0.3";
  sourceHash = "sha256-Uq1oQWtilocQPh6cZ3P/L/L6caCHv17u1y67sm5fhhA=";

  nvidiaLibsPatch = replaceVars ./patch-nvidia-libs-paths_13_0.patch {
    inherit (cudaLibPaths)
      libcudart
      libcufile
      libnvjitlink
      libnvrtc
      libnvvm
      ;
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "cython>=3.1,<3.2" "cython"
  '';

  disabledTests = [
    # Requires the nvidia_fs kernel module (GPUDirect Storage), causing:
    #   cuda.bindings.cufile.cuFileError: NVFS_SETUP_ERROR (5033): NVFS driver initialization error
    "test_buf_register_already_registered"
    "test_buf_register_host_memory"
    "test_buf_register_invalid_flags"
    "test_buf_register_large_buffer"
    "test_buf_register_multiple_buffers"
    "test_buf_register_simple"
    "test_driver_open"
    "test_get_bar_size_in_kb"
    "test_get_parameter_min_max_value"
    "test_set_parameter_posix_pool_slab_array"
    "test_set_stats_level"
    "test_stats_start_stop"
  ];
}
