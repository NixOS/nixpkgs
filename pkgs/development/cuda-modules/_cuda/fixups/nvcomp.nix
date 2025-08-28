_: prevAttrs: {
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
    description = "High-speed data compression and decompression library optimized for NVIDIA GPUs";
    longDescription = ''
      NVIDIA nvCOMP is a high-speed data compression and decompression library optimized for NVIDIA GPUs.
    ''
    + prevAttrs.meta.longDescription;
    homepage = "https://developer.nvidia.com/nvcomp";
    changelog = "https://docs.nvidia.com/cuda/nvcomp/release_notes.html";
  };
}
