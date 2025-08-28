{ flags, lib }:
prevAttrs: {
  autoPatchelfIgnoreMissingDeps = prevAttrs.autoPatchelfIgnoreMissingDeps or [ ] ++ [
    "libnvrm_gpu.so"
    "libnvrm_mem.so"
    "libnvdla_runtime.so"
  ];

  passthru = prevAttrs.passthru or { } // {
    # `cuda_compat` only works on aarch64-linux, and only when building for Jetson devices.
    platformAssertions = prevAttrs.passthru.platformAssertions or [ ] ++ [
      {
        message = "Trying to use cuda_compat on aarch64-linux targeting non-Jetson devices";
        assertion = flags.isJetsonBuild;
      }
    ];

    # NOTE: Using multiple outputs with symlinks causes build cycles.
    # To avoid that (and troubleshooting why), we just use a single output.
    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [ "out" ];
    };
  };

  meta = prevAttrs.meta or { } // {
    description = "Provides minor version forward compatibility for the CUDA runtime";
    homepage = "https://docs.nvidia.com/deploy/cuda-compatibility";
  };
}
