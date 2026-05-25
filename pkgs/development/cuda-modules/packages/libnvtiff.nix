{ buildRedist }:
buildRedist {
  redistName = "nvtiff";
  pname = "libnvtiff";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
    "static"
  ];

  meta = {
    description = "Accelerates TIFF encode/decode on NVIDIA GPUs";
    longDescription = ''
      nvTIFF is a GPU accelerated TIFF(Tagged Image File Format) encode/decode library built on the CUDA platform.
    '';
    homepage = "https://docs.nvidia.com/cuda/nvtiff";
    changelog = "https://docs.nvidia.com/cuda/nvtiff/releasenotes.html";
  };
}
