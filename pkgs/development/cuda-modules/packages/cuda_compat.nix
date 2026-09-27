{
  backendStdenv,
  buildRedist,
  manifests,
}:

let
  cudaCompatManifestEntry = manifests.cuda.cuda_compat or null;
  cudaCompatIsUnsupported =
    cudaCompatManifestEntry == null
    || !(
      cudaCompatManifestEntry ? ${backendStdenv.hostRedistSystem}
      || cudaCompatManifestEntry ? source
      || cudaCompatManifestEntry ? linux-all
    );
in

if cudaCompatIsUnsupported then
  null
else
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
      # Not necessary for the core function
      "libcrypto.so.1.1"
      "libcrypto.so.3"
    ];

    meta = {
      description = "Provides minor version forward compatibility for the CUDA runtime";
      homepage = "https://docs.nvidia.com/deploy/cuda-compatibility";
    };
  }
