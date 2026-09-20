{
  buildRedist,
  cuda_cudart,
  cudaMajorMinorVersion,
  cuda_nvrtc,
  cudaAtLeast,
  lib,
  libnvjitlink,
}:
buildRedist {
  redistName = "cuda";
  pname = "libcufft";

  # dlopen'd for LTO callbacks (cufftXtSetJITCallback, CUFFT_FORCE_LTO). Gated because libnvjitlink
  # does not exist before CUDA 12.0, and 11.x libcufft references neither soname.
  appendRunpaths = lib.optionals (cudaAtLeast "12.0") (
    map (pkg: "${lib.getLib pkg}/lib") [
      cuda_nvrtc # libnvrtc.so.%s
      libnvjitlink # libnvJitLink.so.%s
    ]
  );

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
    "static"
    "stubs"
  ];

  # Public headers include CUDA types; publish the same dependencies to
  # stdenv and to pkg-config consumers.
  propagatedBuildInputs = [ cuda_cudart ];

  postPatch = ''
    substituteInPlace share/pkgconfig/cufft-${cudaMajorMinorVersion}.pc \
      --replace-fail 'Cflags:' $'Requires: cudart-${cudaMajorMinorVersion}\nCflags:'
    substituteInPlace share/pkgconfig/cufftw-${cudaMajorMinorVersion}.pc \
      --replace-fail 'Cflags:' $'Requires: cudart-${cudaMajorMinorVersion}\nCflags:'
  '';

  meta = {
    description = "High-performance FFT product CUDA library";
    homepage = "https://developer.nvidia.com/cufft";
  };
}
