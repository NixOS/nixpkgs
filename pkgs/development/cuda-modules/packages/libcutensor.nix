{
  _cuda,
  buildRedist,
  callPackage,
  cuda_cudart,
  lib,
  libcublas,
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
  ];

  propagatedBuildInputs = [ cuda_cudart ];

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

    license = _cuda.lib.licenses.cutensor;
  };
})
