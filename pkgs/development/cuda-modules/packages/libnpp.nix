{
  buildRedist,
  cuda_cudart,
  cudaMajorMinorVersion,
  cudaOlder,
  lib,
}:
buildRedist {
  redistName = "cuda";
  pname = "libnpp";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
    "static"
    "stubs"
  ];

  propagatedBuildInputs = [ cuda_cudart ];

  postPatch =
    lib.optionalString (cudaOlder "13.4") ''
      # These obsolete modules name libraries absent from the redistributable.
      rm share/pkgconfig/{nppi,nppicom}-${cudaMajorMinorVersion}.pc \
        share/pkgconfig/{nppi,nppicom}.pc

    ''
    + ''
      substituteInPlace share/pkgconfig/npp*-${cudaMajorMinorVersion}.pc \
        --replace-fail 'Cflags:' 'Requires: cudart-${cudaMajorMinorVersion}
      Cflags:'
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
