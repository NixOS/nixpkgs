{
  buildRedist,
  cudaAtLeast,
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

  # Before 13.4 the pkg-config file asks for -lnvjitlink, but the library is libnvJitLink.so.
  postPatch = ''
    sed -i --follow-symlinks 's/-lnvjitlink\b/-lnvJitLink/' share/pkgconfig/*.pc
  '';

  meta = {
    description = "APIs which can be used at runtime to link together GPU device code";
    homepage = "https://docs.nvidia.com/cuda/nvjitlink";
    pkgConfigModules = [
      "nvjitlink"
    ];
  };
}
