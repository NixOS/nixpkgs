{
  buildRedist,
  flags,
}:
buildRedist {
  redistName = "cuda";
  pname = "cuda_compat";

  # NOTE: Using multiple outputs with symlinks causes build cycles.
  # To avoid that (and troubleshooting why), we just use a single output.
  outputs = [ "out" ];

  autoPatchelfIgnoreMissingDeps = [
    "libnvrm_gpu.so"
    "libnvrm_mem.so"
    "libnvdla_runtime.so"
  ];

  # `cuda_compat` only works on aarch64-linux, and only when building for Jetson devices.
  platformAssertions = [
    {
      message = "Trying to use cuda_compat on aarch64-linux targeting non-Jetson devices";
      assertion = flags.isJetsonBuild;
    }
  ];

  meta = {
    description = "Provides minor version forward compatibility for the CUDA runtime";
    homepage = "https://docs.nvidia.com/deploy/cuda-compatibility";
  };
}
