{ buildRedist }:
buildRedist {
  redistName = "cuda";
  pname = "libcufft";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
    "static"
    "stubs"
  ];

  meta = {
    description = "High-performance FFT product CUDA library";
    homepage = "https://developer.nvidia.com/cufft";
  };
}
