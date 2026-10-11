{
  backendStdenv,
  buildRedist,
  lib,
}:
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

  # https://docs.nvidia.com/cuda/nvcomp/installation.html
  platformAssertions = [
    {
      message =
        "nvCOMP supports CUDA compute capabilities 7.0 and newer"
        + " (found ${builtins.toJSON backendStdenv.cudaCapabilities})";
      assertion = lib.all (lib.flip lib.versionAtLeast "7.0") backendStdenv.cudaCapabilities;
    }
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
