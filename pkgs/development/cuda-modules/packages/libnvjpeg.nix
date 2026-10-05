{ buildRedist }:
buildRedist {
  redistName = "cuda";
  pname = "libnvjpeg";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
    "static"
    "stubs"
  ];

  meta = {
    description = "Provides high-performance, GPU accelerated JPEG decoding functionality for image formats commonly used in deep learning and hyperscale multimedia applications";
    longDescription = ''
      The nvJPEG library provides high-performance, GPU accelerated JPEG decoding functionality for image formats
      commonly used in deep learning and hyperscale multimedia applications.
    '';
    homepage = "https://docs.nvidia.com/cuda/nvjpeg";
  };
}
