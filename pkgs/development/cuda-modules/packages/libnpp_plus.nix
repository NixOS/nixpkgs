{
  backendStdenv,
  buildRedist,
  lib,
}:
buildRedist (finalAttrs: {
  redistName = "nppplus";
  pname = "libnpp_plus";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
    "static"
    "stubs"
  ];

  # https://docs.nvidia.com/cuda/nppplus/releasenotes.html
  platformAssertions = [
    {
      message =
        "NPP+ releases since 0.10.0 (found ${finalAttrs.version})"
        + " support CUDA compute capabilities 7.5 and newer (found ${builtins.toJSON backendStdenv.cudaCapabilities})";
      assertion =
        lib.versionAtLeast finalAttrs.version "0.10"
        -> lib.all (lib.flip lib.versionAtLeast "7.5") backendStdenv.cudaCapabilities;
    }
  ];

  meta = {
    description = "C++ support for interfacing with the NVIDIA Performance Primitives (NPP) library";
    longDescription = ''
      NPP is a library of over 5,000 primitives for image and signal processing that lets you easily perform tasks
      such as color conversion, image compression, filtering, thresholding, and image manipulation.
    '';
    homepage = "https://developer.nvidia.com/npp";
    changelog = "https://docs.nvidia.com/cuda/nppplus/releasenotes.html";
  };
})
