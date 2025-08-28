_: prevAttrs: {
  # There's a comment with a reference to /usr
  allowFHSReferences = true;

  passthru = prevAttrs.passthru or { } // {
    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [ "out" ];
    };
  };

  meta = prevAttrs.meta or { } // {
    downloadPage = "https://developer.download.nvidia.com/compute/cuda/redist/cuda_crt";
  };
}
