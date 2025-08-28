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
    description = "Part of NVIDIA Performance Libraries that provides standard Fortran 90 LAPACK and LAPACKE APIs";
    homepage = "https://developer.nvidia.com/nvpl";
    downloadPage = "https://developer.download.nvidia.com/compute/cuda/redist/nvpl_lapack";
    changelog = "https://docs.nvidia.com/nvpl/latest/lapack/release_notes.html";
  };
}
