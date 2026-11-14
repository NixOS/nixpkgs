{
  _cuda,
  buildRedist,
  cuda_nvrtc,
  cudaAtLeast,
  cudaMajorMinorVersion,
  lib,
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

  # libcusparseLt dlopens NVRTC (the CASK kernel compiler) from 0.7.
  appendRunpaths = lib.optionals (lib.versionAtLeast finalAttrs.version "0.7") [
    "${lib.getLib cuda_nvrtc}/lib" # libnvrtc.so.%s
  ];

  # NOTE: libcusparseLt does not reference libcublas at all, so it is deliberately not an input.

  # NOTE: cuSPARSELt documents a minimum supported CUDA compute capability of 8.0:
  # https://docs.nvidia.com/cuda/cusparselt/getting_started.html#prerequisites
  # We do not assert on this, as it would make cuSPARSELt unavailable with the default CUDA capabilities (which include
  # 7.5); consumers built for older capabilities still work, but cannot use cuSPARSELt on those devices.

  # NOTE: From 0.9.0, cuSPARSELt only provides builds for CUDA 13.
  # https://docs.nvidia.com/cuda/cusparselt/release_notes.html
  platformAssertions =
    let
      cusparseltAtLeast = lib.versionAtLeast finalAttrs.version;
    in
    [
      {
        message =
          "cuSPARSELt releases since 0.7.0 (found ${finalAttrs.version})"
          + " support CUDA 12.8 and newer (found ${cudaMajorMinorVersion})";
        assertion = cusparseltAtLeast "0.7" -> cudaAtLeast "12.8";
      }
      {
        message =
          "cuSPARSELt releases since 0.8.0 (found ${finalAttrs.version})"
          + " support CUDA 12.9 and newer (found ${cudaMajorMinorVersion})";
        assertion = cusparseltAtLeast "0.8" -> cudaAtLeast "12.9";
      }
    ];

  meta = {
    description = "High-performance CUDA library dedicated to general matrix-matrix operations in which at least one operand is a structured sparse matrix with 50% sparsity ratio";
    longDescription = ''
      NVIDIA cuSPARSELt is a high-performance CUDA library dedicated to general matrix-matrix operations in which at
      least one operand is a structured sparse matrix with 50% sparsity ratio.
    '';
    homepage = "https://developer.nvidia.com/cusparselt-downloads";
    changelog = "https://docs.nvidia.com/cuda/cusparselt/release_notes.html";

    maintainers = [ lib.maintainers.sepiabrown ];
    license = lib.licenses.nvidiaCusparse_lt;
  };
})
