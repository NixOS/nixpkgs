{
  buildRedist,
  config,
  lib,
}:
buildRedist {
  redistName = "cuda";
  pname = "cuda_compat";

  # NOTE: Using multiple outputs with symlinks causes build cycles.
  # To avoid that (and troubleshooting why), we just use a single output.
  outputs = [ "out" ];

  autoPatchelfIgnoreMissingDeps = [
    "libnvdla_runtime.so"
    "libnvrm_gpu.so"
    "libnvrm_mem.so"
  ];

  meta = {
    description = "Provides minor version forward compatibility for the CUDA runtime";
    homepage = "https://docs.nvidia.com/deploy/cuda-compatibility";
    problems = lib.optionalAttrs (!config.enableCudaDriverCompat) {
      cuda-compat-disabled = {
        kind = "broken";
        message = "cuda_compat must be explicitly enabled using config.enableCudaDriverCompat.";
      };
    };
  };
}
