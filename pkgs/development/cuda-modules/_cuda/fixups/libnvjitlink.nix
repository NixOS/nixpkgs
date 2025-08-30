_: prevAttrs: {
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
    description = "APIs which can be used at runtime to link together GPU device code";
    homepage = "https://docs.nvidia.com/cuda/nvjitlink";
    downloadPage = "https://developer.download.nvidia.com/compute/cuda/redist/libnvjitlink";
  };
}
