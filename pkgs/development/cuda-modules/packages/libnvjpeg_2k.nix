{
  backendStdenv,
  buildRedist,
  cudaAtLeast,
  cudaMajorMinorVersion,
  lib,
}:
buildRedist {
  redistName = "nvjpeg2000";
  pname = "libnvjpeg_2k";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
    "static"
  ];

  # https://docs.nvidia.com/cuda/nvjpeg2000/index.html
  platformAssertions = [
    {
      message =
        "nvJPEG2000 supports CUDA compute capabilities 6.0 and newer"
        + " (found ${builtins.toJSON backendStdenv.cudaCapabilities})";
      assertion = lib.all (lib.flip lib.versionAtLeast "6.0") backendStdenv.cudaCapabilities;
    }
    {
      message =
        "nvJPEG2000 supports Jetson Orin (8.7) with linux-sbsa from CUDA 13.2"
        + " (found ${cudaMajorMinorVersion})";
      assertion =
        backendStdenv.hostRedistSystem == "linux-sbsa" && lib.elem "8.7" backendStdenv.cudaCapabilities
        -> cudaAtLeast "13.2";
    }
  ];

  meta = {
    description = "Accelerates the decoding and encoding of JPEG2000 images on NVIDIA GPUs";
    longDescription = ''
      The nvJPEG2000 library accelerates the decoding and encoding of JPEG2000 images on NVIDIA GPUs.
    '';
    homepage = "https://docs.nvidia.com/cuda/nvjpeg2000";
    changelog = "https://docs.nvidia.com/cuda/nvjpeg2000/releasenotes.html";
  };
}
