{
  buildRedist,
  cuda_cudart,
  cudaMajorMinorVersion,
  cudaAtLeast,
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

  buildInputs =
    # Always depends on this
    [ (lib.getLib libcublas) ]
    # Dependency from 12.0 and on
    ++ lib.optionals (cudaAtLeast "12.0") [ libnvjitlink ]
    # Dependency from 12.1 and on
    ++ lib.optionals (cudaAtLeast "12.1") [ (lib.getLib libcusparse) ];

  # Public headers include CUDA types; publish the same dependencies to
  # stdenv and to pkg-config consumers.
  propagatedBuildInputs = [
    cuda_cudart
    libcublas
    libcusparse
  ];

  postPatch = ''
    substituteInPlace share/pkgconfig/cusolver-${cudaMajorMinorVersion}.pc \
      --replace-fail 'Cflags:' $'Requires: cudart-${cudaMajorMinorVersion} cublas-${cudaMajorMinorVersion} cusparse-${cudaMajorMinorVersion}\nCflags:'
  '';

  meta = {
    description = "Collection of dense and sparse direct linear solvers and Eigen solvers";
    longDescription = ''
      The NVIDIA cuSOLVER library provides a collection of dense and sparse direct linear solvers and Eigen solvers
      which deliver significant acceleration for Computer Vision, CFD, Computational Chemistry, and Linear
      Optimization applications.
    '';
    homepage = "https://developer.nvidia.com/cusolver";
    # The static output vendors METIS 5.1.0 (lib/libmetis_static.a).
    license = [
      lib.licenses.nvidiaCudaRedist
      lib.licenses.asl20
    ];
  };
}
