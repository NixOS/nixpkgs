args@{
  buildRedist,
  cuda_cudart,
  cudaAtLeast,
  cudaMajorMinorVersion,
  lib,
}:
(import ../library.nix args) {
  pname = "libcurand";

  # CUDA 13.5 links the runtime dynamically.
  buildInputs = lib.optionals (cudaAtLeast "13.5") [ cuda_cudart ];

  meta = {
    description = "GPU-accelerated random number generation library";
    longDescription = ''
      The cuRAND library provides facilities that focus on the simple and efficient generation of high-quality
      pseudorandom and quasirandom numbers.
    '';
    homepage = "https://developer.nvidia.com/curand";
  };
}
