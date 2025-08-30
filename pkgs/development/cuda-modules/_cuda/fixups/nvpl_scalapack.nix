_: prevAttrs: {
  passthru = prevAttrs.passthru or { } // {
    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [
        "out"
        "dev"
        "include"
        "lib"
      ];
    };
  };

  meta = prevAttrs.meta or { } // {
    description = "Provides an optimized implementation of ScaLAPACK for distributed-memory architectures";
    homepage = "https://developer.nvidia.com/nvpl";
    downloadPage = "https://developer.download.nvidia.com/compute/cuda/redist/nvpl_scalapack";
    changelog = "https://docs.nvidia.com/nvpl/latest/scalapack/release_notes.html";
  };
}
