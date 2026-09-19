{
  buildRedist,
  cudaAtLeast,
  cudaMajorMinorVersion,
  cudaOlder,
  lib,
}:
buildRedist {
  redistName = "cuda";
  pname = "libnvjitlink";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
    "static"
  ]
  ++ lib.optionals (cudaAtLeast "12.2") [ "stubs" ];

  postPatch = lib.optionalString (cudaOlder "13.4") ''
    substituteInPlace share/pkgconfig/nvjitlink-${cudaMajorMinorVersion}.pc \
      --replace-fail '-lnvjitlink' '-lnvJitLink'
  '';

  meta = {
    description = "APIs which can be used at runtime to link together GPU device code";
    homepage = "https://docs.nvidia.com/cuda/nvjitlink";
  };
}
