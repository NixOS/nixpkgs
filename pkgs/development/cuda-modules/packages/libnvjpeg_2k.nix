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

  meta = {
    description = "Accelerates the decoding and encoding of JPEG2000 images on NVIDIA GPUs";
    longDescription = ''
      The nvJPEG2000 library accelerates the decoding and encoding of JPEG2000 images on NVIDIA GPUs.
    '';
    homepage = "https://docs.nvidia.com/cuda/nvjpeg2000";
    changelog = "https://docs.nvidia.com/cuda/nvjpeg2000/releasenotes.html";
    # https://docs.nvidia.com/cuda/nvjpeg2000/index.html
    problems =
      lib.optionalAttrs (!lib.all (lib.flip lib.versionAtLeast "6.0") backendStdenv.cudaCapabilities)
        {
          capabilityBelow60 = {
            kind = "unsupported";
            message =
              "nvJPEG2000 requires CUDA compute capabilities 6.0 and newer"
              + " (found ${builtins.toJSON backendStdenv.cudaCapabilities}).";
          };
        };
  };
}
