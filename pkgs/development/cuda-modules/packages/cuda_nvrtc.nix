{
  buildRedist,
  cudaAtLeast,
  lib,
}:
buildRedist {
  redistName = "cuda";
  pname = "cuda_nvrtc";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
  ]
  ++ lib.optionals (cudaAtLeast "11.5") [ "static" ]
  ++ [ "stubs" ];

  allowFHSReferences = true;

  meta = {
    description = "Runtime compilation library for CUDA C++";
    longDescription = ''
      NVRTC is a runtime compilation library for CUDA C++. It accepts CUDA C++ source code in character string form
      and creates handles that can be used to obtain the PTX.
    '';
    homepage = "https://docs.nvidia.com/cuda/nvrtc";
  };
}
