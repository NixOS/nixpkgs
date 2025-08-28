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
    description = "Provides a set of CPU-accelerated basic linear algebra subroutines used for handling sparse matrices";
    homepage = "https://developer.nvidia.com/nvpl";
    changelog = "https://docs.nvidia.com/nvpl/latest/sparse/release_notes.html";
  };
}
