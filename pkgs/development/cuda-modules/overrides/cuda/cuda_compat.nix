{ cudaFlags, lib }:
prevAttrs: {
  allowFHSReferences = true;
  autoPatchelfIgnoreMissingDeps = prevAttrs.autoPatchelfIgnoreMissingDeps ++ [
    "libnvrm_gpu.so"
    "libnvrm_mem.so"
    "libnvdla_runtime.so"
  ];
  # `cuda_compat` only works on aarch64-linux, and only when building for Jetson devices.
  badPlatformsConditions = prevAttrs.badPlatformsConditions // {
    "Trying to use cuda_compat on aarch64-linux targeting non-Jetson devices" =
      !cudaFlags.isJetsonBuild;
  };
}
