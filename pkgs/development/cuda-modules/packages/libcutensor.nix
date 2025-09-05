{
  _cuda,
  buildRedist,
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
  ]
  # For some reason, the 1.4.x release of cuTENSOR requires the cudart library.
  ++ lib.optionals (lib.hasPrefix "1.4" finalAttrs.version) [ (lib.getLib cuda_cudart) ];

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

    maintainers = [ lib.maintainers.obsidian-systems-maintenance ];
    license = _cuda.lib.licenses.cutensor;
  };
})
