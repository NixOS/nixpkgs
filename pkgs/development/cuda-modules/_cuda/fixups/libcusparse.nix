{ libnvjitlink }:
prevAttrs: {
  buildInputs = prevAttrs.buildInputs or [ ] ++ [ libnvjitlink ];

  passthru = prevAttrs.passthru or { } // {
    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [
        "out"
        "dev"
        "include"
        "lib"
        "static"
        "stubs"
      ];
    };
  };

  meta = prevAttrs.meta or { } // {
    description = "GPU-accelerated basic linear algebra subroutines for sparse matrix computations for unstructured sparsity";
    longDescription = ''
      The cuSPARSE APIs provides GPU-accelerated basic linear algebra subroutines for sparse matrix computations for
      unstructured sparsity.
    ''
    + prevAttrs.meta.longDescription;
    homepage = "https://developer.nvidia.com/cusparse";
    downloadPage = "https://developer.download.nvidia.com/compute/cuda/redist/libcusparse";
    changelog = "https://docs.nvidia.com/cuda/cusparse";
  };
}
