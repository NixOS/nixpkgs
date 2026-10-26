{
  backendStdenv,
  buildRedist,
  lib,
}:
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
    # https://docs.nvidia.com/cuda/nvtiff/index.html
    problems =
      lib.optionalAttrs (!lib.all (lib.flip lib.versionAtLeast "7.0") backendStdenv.cudaCapabilities)
        {
          capabilityBelow70 = {
            kind = "unsupported";
            message =
              "nvTIFF requires CUDA compute capabilities 7.0 and newer"
              + " (found ${builtins.toJSON backendStdenv.cudaCapabilities}).";
          };
        };
  };
}
