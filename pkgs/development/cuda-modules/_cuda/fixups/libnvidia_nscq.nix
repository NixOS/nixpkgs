_: prevAttrs: {
  allowFHSReferences = true;

  passthru = prevAttrs.passthru or { } // {
    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [
        "out"
        "lib"
      ];
    };
  };

  meta = prevAttrs.meta or { } // {
    downloadPage = "https://developer.download.nvidia.com/compute/cuda/redist/libnvidia_nscq";
  };
}
