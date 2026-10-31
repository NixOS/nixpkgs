{
  backendStdenv,
  buildRedist,
  cuda_cudart,
  cudaAtLeast,
  cudaMajorMinorPatchVersion,
  cudaMajorVersion,
  lib,
  libcublas,
  libcublasmp,
  libcusolver,
  nccl,
}:
buildRedist (
  finalAttrs:
  let
    inherit (backendStdenv) cudaCapabilities;
    cusolvermpAtLeast = lib.versionAtLeast finalAttrs.version;
    cusolvermpOlder = lib.versionOlder finalAttrs.version;
  in
  {
    redistName = "cusolvermp";
    pname = "libcusolvermp";

    outputs = [
      "out"
      "dev"
      "include"
      "lib"
    ];

    buildInputs = [
      cuda_cudart
      libcublas
      libcusolver
      nccl
    ]
    # cuSOLVERMp links against cuBLASMp from 0.9.0.
    ++ lib.optionals (cusolvermpAtLeast "0.9") [ libcublasmp ];

    autoPatchelfIgnoreMissingDeps = [
      # Needs to be dynamically loaded as it depends on the hardware
      "libcuda.so.1"
    ];

    # https://docs.nvidia.com/cuda/cusolvermp/getting_started/index.html#hardware-and-software-requirements
    platformAssertions =
      let
        minCudaCapability = if cudaAtLeast "13.0" then "7.5" else "7.0";
      in
      [
        {
          message =
            "cuSOLVERMp for CUDA ${cudaMajorVersion} supports CUDA compute capabilities ${minCudaCapability} and newer"
            + " (found ${builtins.toJSON cudaCapabilities})";
          assertion = lib.all (lib.flip lib.versionAtLeast minCudaCapability) cudaCapabilities;
        }
        {
          message = "cuSOLVERMp requires NCCL, which is unavailable for this platform";
          assertion = nccl.meta.available;
        }
      ];

    # https://docs.nvidia.com/cuda/cusolvermp/release_notes/index.html
    # NOTE: The getting started page requires NCCL 2.29.2 or newer; we apply the requirement from 0.9.0, since that is
    # when cuSOLVERMp started depending on cuBLASMp 0.9.1 or newer, which requires it (see libcublasmp.nix).
    brokenAssertions = [
      {
        message =
          "cuSOLVERMp releases since 0.9.0 (found ${finalAttrs.version})"
          + " require cuBLASMp 0.9.1 or newer (found ${libcublasmp.version})";
        assertion = cusolvermpAtLeast "0.9" -> lib.versionAtLeast libcublasmp.version "0.9.1";
      }
      {
        message =
          "cuSOLVERMp releases since 0.9.0 (found ${finalAttrs.version})"
          + " require NCCL 2.29.2 or newer (found ${nccl.version})";
        assertion = cusolvermpAtLeast "0.9" -> lib.versionAtLeast nccl.version "2.29.2";
      }
      {
        message =
          "cuSOLVERMp releases before 0.9.0 (found ${finalAttrs.version}) under-report device workspace sizes"
          + " when used with cuSOLVER from CUDA 13.2 Update 1 and newer (found ${cudaMajorMinorPatchVersion})";
        assertion = cusolvermpOlder "0.9" -> lib.versionOlder cudaMajorMinorPatchVersion "13.2.1";
      }
    ];

    meta = {
      description = "High-performance, distributed-memory, GPU-accelerated library that provides tools for solving dense linear systems and eigenvalue problems";
      longDescription = ''
        The NVIDIA cuSOLVERMp library is a high-performance, distributed-memory, GPU-accelerated library that provides
        tools for solving dense linear systems and eigenvalue problems.
      '';
      homepage = "https://developer.nvidia.com/cusolver";
      changelog = "https://docs.nvidia.com/cuda/cusolvermp/release_notes";
    };
  }
)
