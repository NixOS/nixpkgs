{ nvpl_blas }:
prevAttrs: {
  buildInputs = prevAttrs.buildInputs or [ ] ++ [ nvpl_blas ];

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
    description = "Part of NVIDIA Performance Libraries that provides tensor primitives";
    homepage = "https://developer.nvidia.com/nvpl";
    downloadPage = "https://developer.download.nvidia.com/compute/cuda/redist/nvpl_tensor";
    changelog = "https://docs.nvidia.com/nvpl/latest/tensor/release_notes.html";
  };
}
