{
  backendStdenv,
  buildRedist,
  cudaAtLeast,
  cudaMajorVersion,
  lib,
  libcublas,
  nccl,
}:
buildRedist (
  finalAttrs:
  let
    inherit (backendStdenv) cudaCapabilities;
    cublasmpAtLeast = lib.versionAtLeast finalAttrs.version;
  in
  {
    redistName = "cublasmp";
    pname = "libcublasmp";

    outputs = [
      "out"
      "dev"
      "include"
      "lib"
    ];

    # NOTE: cuBLASMp has not depended on NVSHMEM since 0.8.0:
    # https://docs.nvidia.com/cuda/cublasmp/release_notes/index.html
    buildInputs = [
      libcublas
      nccl
    ];

    autoPatchelfIgnoreMissingDeps = [
      "libcuda.so.1"
    ];

    meta = {
      description = "High-performance, multi-process, GPU-accelerated library for distributed basic dense linear algebra";
      longDescription = ''
        NVIDIA cuBLASMp is a high-performance, multi-process, GPU-accelerated library for distributed basic dense linear
        algebra.

        cuBLASMp is compatible with 2D block-cyclic data layout and provides PBLAS-like C APIs.
      '';
      homepage = "https://docs.nvidia.com/cuda/cublasmp";
      changelog = "https://docs.nvidia.com/cuda/cublasmp/release_notes";
      license = lib.licenses.nvidiaMath_sdk_sla;

      # https://docs.nvidia.com/cuda/cublasmp/getting_started/index.html#hardware-and-software-requirements
      problems =
        let
          minCudaCapability = if cudaAtLeast "13.0" then "7.5" else "7.0";
        in
        lib.optionalAttrs (!lib.all (lib.flip lib.versionAtLeast minCudaCapability) cudaCapabilities) {
          capabilityTooOld = {
            kind = "unsupported";
            message =
              "cuBLASMp for CUDA ${cudaMajorVersion} requires CUDA compute capabilities ${minCudaCapability} and newer"
              + " (found ${builtins.toJSON cudaCapabilities}).";
          };
        }
        // lib.optionalAttrs (!nccl.meta.available) {
          ncclUnavailable = {
            kind = "unsupported";
            message = "cuBLASMp requires NCCL, which is unavailable for this platform.";
          };
        }
        # NOTE: The requirement was raised to NCCL 2.29.2 when cuBLASMp 0.8.0 replaced NVSHMEM with NCCL symmetric memory:
        # https://web.archive.org/web/20260215220513/https://docs.nvidia.com/cuda/cublasmp/getting_started/index.html
        // lib.optionalAttrs (cublasmpAtLeast "0.8" && !(lib.versionAtLeast nccl.version "2.29.2")) {
          ncclTooOld = {
            kind = "broken";
            message =
              "cuBLASMp releases since 0.8.0 (found ${finalAttrs.version})"
              + " require NCCL 2.29.2 or newer (found ${nccl.version}).";
          };
        };
    };
  }
)
