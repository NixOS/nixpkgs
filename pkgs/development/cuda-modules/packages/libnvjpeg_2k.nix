{
  backendStdenv,
  buildRedist,
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
