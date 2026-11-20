{
  _cuda,
  backendStdenv,
  buildRedist,
  cuda_cudart,
  lib,
  libcublas,
  nccl,
}:
buildRedist (finalAttrs: {
  redistName = "cutensor";
  pname = "libcutensor";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
    "static"
  ];

  allowFHSReferences = true;

  buildInputs = [
    (lib.getLib libcublas)
  ]
  # For some reason, the 1.4.x release of cuTENSOR requires the cudart library.
  ++ lib.optionals (lib.hasPrefix "1.4" finalAttrs.version) [ (lib.getLib cuda_cudart) ]
  # libcutensorMp (beta since 2.4.0) links against libcudart and libnccl.
  ++ lib.optionals (lib.versionAtLeast finalAttrs.version "2.4") (
    [ (lib.getLib cuda_cudart) ] ++ lib.optionals nccl.meta.available [ (lib.getLib nccl) ]
  );

  # NCCL is not available on all platforms (e.g., Jetson Orin); libcutensorMp is unusable without it.
  autoPatchelfIgnoreMissingDeps = lib.optionals (!nccl.meta.available) [ "libnccl.so.2" ];

  # https://docs.nvidia.com/cuda/cutensor/latest/release_notes.html
  # NOTE: Support for Turing (7.5) is deprecated as of 2.8.0.
  platformAssertions =
    let
      inherit (backendStdenv) cudaCapabilities;
      cutensorAtLeast23 = lib.versionAtLeast finalAttrs.version "2.3";
      allCCNewerThan75 = lib.all (lib.flip lib.versionAtLeast "7.5") cudaCapabilities;
    in
    [
      {
        message =
          "cuTENSOR releases since 2.3.0 (found ${finalAttrs.version})"
          + " support CUDA compute capabilities 7.5 and newer (found ${builtins.toJSON cudaCapabilities})";
        assertion = cutensorAtLeast23 -> allCCNewerThan75;
      }
    ];

  meta = {
    description = "GPU-accelerated tensor linear algebra library for tensor contraction, reduction, and elementwise operations";
    longDescription = ''
      NVIDIA cuTENSOR is a GPU-accelerated tensor linear algebra library for tensor contraction, reduction, and
      elementwise operations. Using cuTENSOR, applications can harness the specialized tensor cores on NVIDIA GPUs for
      high-performance tensor computations and accelerate deep learning training and inference, computer vision,
      quantum chemistry, and computational physics workloads.
    '';
    homepage = "https://developer.nvidia.com/cutensor";
    changelog = "https://docs.nvidia.com/cuda/cutensor/latest/release_notes.html";

    license = lib.licenses.nvidiaCutensor;
  };
})
