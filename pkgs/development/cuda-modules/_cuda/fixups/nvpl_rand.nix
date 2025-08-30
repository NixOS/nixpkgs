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
    description = "Collection of efficient pseudorandom and quasirandom number generators for ARM CPUs";
    homepage = "https://developer.nvidia.com/nvpl";
    downloadPage = "https://developer.download.nvidia.com/compute/cuda/redist/nvpl_rand";
    changelog = "https://docs.nvidia.com/nvpl/latest/rand/release_notes.html";
  };
}
