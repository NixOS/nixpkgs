{
  _cuda,
  buildRedist,
  cuda_cudart,
  lib,
  libcublas,
}:
buildRedist (finalAttrs: {
  redistName = "cusparselt";
  pname = "libcusparse_lt";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
    "static"
  ];

  buildInputs = [
    (lib.getLib libcublas)
  ]
  # For some reason, the 1.4.x release of cusparselt requires the cudart library.
  ++ lib.optionals (lib.hasPrefix "1.4" finalAttrs.version) [ (lib.getLib cuda_cudart) ];

  meta = {
    description = "High-performance CUDA library dedicated to general matrix-matrix operations in which at least one operand is a structured sparse matrix with 50% sparsity ratio";
    longDescription = ''
      NVIDIA cuSPARSELt is a high-performance CUDA library dedicated to general matrix-matrix operations in which at
      least one operand is a structured sparse matrix with 50% sparsity ratio.
    '';
    homepage = "https://developer.nvidia.com/cusparselt-downloads";
    changelog = "https://docs.nvidia.com/cuda/cublasmp/release_notes";

    maintainers = [ lib.maintainers.sepiabrown ];
    license = _cuda.lib.licenses.cusparse_lt;
  };
})
