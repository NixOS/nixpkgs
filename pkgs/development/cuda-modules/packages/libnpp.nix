args@{
  buildRedist,
  cuda_cudart,
  cudaMajorMinorVersion,
  cudaOlder,
  lib,
}:
(import ../library.nix args) {
  pname = "libnpp";

  postPatch = lib.optionalString (cudaOlder "13.4") ''
    # Older archives include these obsolete modules for nonexistent libraries;
    # newer patch releases already omit them.
    rm -f share/pkgconfig/{nppi,nppicom}-${cudaMajorMinorVersion}.pc \
      share/pkgconfig/{nppi,nppicom}.pc
  '';

  meta = {
    description = "Library of primitives for image and signal processing";
    longDescription = ''
      NPP is a library of over 5,000 primitives for image and signal processing that lets you easily perform tasks
      such as color conversion, image compression, filtering, thresholding, and image manipulation.
    '';
    homepage = "https://developer.nvidia.com/npp";
  };
}
