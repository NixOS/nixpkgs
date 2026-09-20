{
  _cuda,
  buildRedist,
  callPackage,
  cuda_cudart,
  cuda_nvrtc,
  lib,
  libcusparse,
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

  # libcusparseLt dlopens NVRTC (the CASK kernel compiler) from 0.8.
  appendRunpaths = lib.optionals (lib.versionAtLeast finalAttrs.version "0.8") [
    "${lib.getLib cuda_nvrtc}/lib" # libnvrtc.so.%s
  ];

  propagatedBuildInputs = [
    cuda_cudart
    libcusparse
  ];

  passthru.tests.headers = callPackage ./tests/public-headers.nix {
    package = finalAttrs.finalPackage;
    headers = [ "cusparseLt.h" ];
    libraries = [ "cusparseLt" ];
    symbols = [ "cusparseLtGetVersion" ];
  };

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
