{
  buildRedist,
  cuda_cudart,
  cudaAtLeast,
  lib,
}:
buildRedist {
  redistName = "cuda";
  pname = "libcurand";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
    "static"
    "stubs"
  ];

  # From CUDA 13.5 (cuRAND 10.4.5), libcurand.so links against libcudart.so.
  buildInputs = lib.optionals (cudaAtLeast "13.5") [ cuda_cudart ];

  meta = {
    description = "GPU-accelerated random number generation library";
    longDescription = ''
      The cuRAND library provides facilities that focus on the simple and efficient generation of high-quality
      pseudorandom and quasirandom numbers.
    '';
    homepage = "https://developer.nvidia.com/curand";
    pkgConfigModules = [
      "curand"
    ];
  };
}
