{
  buildRedist,
  cudaMajorMinorVersion,
  cudaOlder,
  lib,
}:
buildRedist {
  redistName = "cuda";
  pname = "cuda_opencl";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
  ];

  # NVIDIA corrected the library's case in the CUDA 13.4 metadata.
  postPatch = lib.optionalString (cudaOlder "13.4") ''
    substituteInPlace share/pkgconfig/opencl-${cudaMajorMinorVersion}.pc \
      --replace-fail '-lopencl' '-lOpenCL'
  '';

  meta = {
    description = "Low-level API for heterogeneous computing that runs on CUDA-powered GPUs";
    longDescription = ''
      OpenCL™ (Open Computing Language) is a low-level API for heterogeneous computing that runs on CUDA-powered GPUs.
      Using the OpenCL API, developers can launch compute kernels written using a limited subset of the C programming
      language on a GPU.
    '';
    homepage = "https://developer.nvidia.com/opencl";
  };
}
