{ buildRedist }:
buildRedist {
  redistName = "cuda";
  pname = "cuda_opencl";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
  ];

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
