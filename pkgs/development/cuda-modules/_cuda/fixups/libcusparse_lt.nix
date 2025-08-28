{
  _cuda,
  cuda_cudart,
  lib,
  libcublas,
}:
finalAttrs: prevAttrs: {
  buildInputs =
    prevAttrs.buildInputs or [ ]
    ++ [ (lib.getLib libcublas) ]
    # For some reason, the 1.4.x release of cusparselt requires the cudart library.
    ++ lib.optionals (lib.hasPrefix "1.4" finalAttrs.version) [ (lib.getLib cuda_cudart) ];

  passthru = prevAttrs.passthru or { } // {
    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [
        "out"
        "dev"
        "include"
        "lib"
        "static"
      ];
    };
  };

  meta = prevAttrs.meta or { } // {
    description = "High-performance CUDA library dedicated to general matrix-matrix operations in which at least one operand is a structured sparse matrix with 50% sparsity ratio";
    longDescription = ''
      NVIDIA cuSPARSELt is a high-performance CUDA library dedicated to general matrix-matrix operations in which at
      least one operand is a structured sparse matrix with 50% sparsity ratio.
    ''
    + prevAttrs.meta.longDescription;
    homepage = "https://developer.nvidia.com/cusparselt-downloads";
    changelog = "https://docs.nvidia.com/cuda/cublasmp/release_notes";

    maintainers = prevAttrs.meta.maintainers or [ ] ++ [ lib.maintainers.sepiabrown ];
    license = _cuda.lib.licenses.cusparse_lt;
  };
}
