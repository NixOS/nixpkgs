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
    description = "Library of primitives for image and signal processing";
    longDescription = ''
      NPP is a library of over 5,000 primitives for image and signal processing that lets you easily perform tasks
      such as color conversion, image compression, filtering, thresholding, and image manipulation.
    ''
    + prevAttrs.meta.longDescription;
    homepage = "https://developer.nvidia.com/npp";
    downloadPage = "https://developer.download.nvidia.com/compute/cuda/redist/libnpp";
  };
}
