{
  buildRedist,
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

  # Before 13.4 the pkg-config file asks for -lopencl, but the library is libOpenCL.so.
  postPatch = lib.optionalString (cudaOlder "13.4") ''
    substituteInPlace share/pkgconfig/opencl-*.pc --replace-fail "-lopencl" "-lOpenCL"
  '';

  meta = {
    description = "Low-level API for heterogeneous computing that runs on CUDA-powered GPUs";
    longDescription = ''
      OpenCL™ (Open Computing Language) is a low-level API for heterogeneous computing that runs on CUDA-powered GPUs.
      Using the OpenCL API, developers can launch compute kernels written using a limited subset of the C programming
      language on a GPU.
    '';
    homepage = "https://developer.nvidia.com/opencl";
    pkgConfigModules = [
      "opencl"
    ];
  };
}
