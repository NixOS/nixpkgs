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
    description = "Provides high-performance, GPU accelerated JPEG decoding functionality for image formats commonly used in deep learning and hyperscale multimedia applications";
    longDescription = ''
      The nvJPEG library provides high-performance, GPU accelerated JPEG decoding functionality for image formats
      commonly used in deep learning and hyperscale multimedia applications.
    ''
    + prevAttrs.meta.longDescription;
    homepage = "https://docs.nvidia.com/cuda/nvjpeg";
    downloadPage = "https://developer.download.nvidia.com/compute/cuda/redist/libnvjpeg";
  };
}
