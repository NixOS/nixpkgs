{ buildRedist }:
buildRedist {
  redistName = "nvcomp";
  pname = "nvcomp";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
    "static"
  ];

  meta = {
    description = "High-speed data compression and decompression library optimized for NVIDIA GPUs";
    longDescription = ''
      NVIDIA nvCOMP is a high-speed data compression and decompression library optimized for NVIDIA GPUs.
    '';
    homepage = "https://developer.nvidia.com/nvcomp";
    changelog = "https://docs.nvidia.com/cuda/nvcomp/release_notes.html";
  };
}
