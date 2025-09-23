{
  buildRedist,
  lib,
  libcublas,
  libcusparse,
  libnvjitlink,
}:
buildRedist {
  redistName = "cuda";
  pname = "libcusolver";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
    "static"
    "stubs"
  ];

  buildInputs = [
    (lib.getLib libcublas)
    (lib.getLib libcusparse)
    libnvjitlink
  ];

  meta = {
    description = "Collection of dense and sparse direct linear solvers and Eigen solvers";
    longDescription = ''
      The NVIDIA cuSOLVER library provides a collection of dense and sparse direct linear solvers and Eigen solvers
      which deliver significant acceleration for Computer Vision, CFD, Computational Chemistry, and Linear
      Optimization applications.
    '';
    homepage = "https://developer.nvidia.com/cusolver";
  };
}
