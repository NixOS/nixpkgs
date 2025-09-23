{ buildRedist }:
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

  meta = {
    description = "Provides minor version forward compatibility for the CUDA runtime";
    homepage = "https://docs.nvidia.com/deploy/cuda-compatibility";
  };
}
