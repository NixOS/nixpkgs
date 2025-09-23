{ buildRedist }:
buildRedist {
  redistName = "cuda";
  pname = "libnvjitlink";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
    "static"
    "stubs"
  ];

  meta = {
    description = "APIs which can be used at runtime to link together GPU device code";
    homepage = "https://docs.nvidia.com/cuda/nvjitlink";
  };
}
