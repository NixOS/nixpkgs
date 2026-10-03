{
  _cuda,
  buildRedist,
  callPackage,
  cudaConfig,
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
  # libcutensorMp (beta since 2.4.0) also links against libnccl; libcudart is propagated below.
  ++ lib.optionals (lib.versionAtLeast finalAttrs.version "2.4" && nccl.meta.available) [
    (lib.getLib nccl)
  ];

  propagatedBuildInputs = [ cuda_cudart ];

  # NCCL is not available on all platforms (e.g., Jetson Orin); libcutensorMp is unusable without it.
  autoPatchelfIgnoreMissingDeps = lib.optionals (!nccl.meta.available) [ "libnccl.so.2" ];

  # https://docs.nvidia.com/cuda/cutensor/latest/release_notes.html
  # NOTE: Support for Turing (7.5) is deprecated as of 2.8.0.
  platformAssertions =
    let
      inherit (cudaConfig) cudaCapabilities;
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

  passthru.tests.headers = callPackage ./tests/public-headers.nix {
    package = finalAttrs.finalPackage;
    headers = [
      "cutensor.h"
      "cutensorMg.h"
    ];
    libraries = [
      "cutensor"
      "cutensorMg"
    ];
    symbols = [
      "cutensorGetVersion"
      "cutensorMgCreate"
    ];
  };

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
