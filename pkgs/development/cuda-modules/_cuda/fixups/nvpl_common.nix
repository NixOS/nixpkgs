_: prevAttrs: {
  passthru = prevAttrs.passthru or { } // {
    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [
        "out"
        "dev"
      ];
    };
  };

  meta = prevAttrs.meta or { } // {
    description = "Common part of NVIDIA Performance Libraries";
    homepage = "https://developer.nvidia.com/nvpl";
    changelog = "https://docs.nvidia.com/nvpl/latest/release_notes.html";
  };
}
