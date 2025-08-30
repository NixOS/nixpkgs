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
    description = "Accelerates the decoding and encoding of JPEG2000 images on NVIDIA GPUs";
    longDescription = ''
      The nvJPEG2000 library accelerates the decoding and encoding of JPEG2000 images on NVIDIA GPUs.
    ''
    + prevAttrs.meta.longDescription;
    homepage = "https://docs.nvidia.com/cuda/nvjpeg2000";
    downloadPage = "https://developer.download.nvidia.com/compute/nvjpeg2k/redist/libnvjpeg_2k";
    changelog = "https://docs.nvidia.com/cuda/nvjpeg2000/releasenotes.html";
  };
}
