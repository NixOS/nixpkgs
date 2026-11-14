{
  buildRedist,
  cudaOlder,
  lib,
  manifests,
}:
buildRedist {
  redistName = "cuda";
  pname = "libnvptxcompiler";

  outputs = [ "out" ];

  # CUDA 12 bundles this CPU library with NVCC. Give it ordinary library
  # semantics so a cross compiler can select it for TARGET independently of
  # the NVIDIA executables it runs on HOST.
  release = manifests.cuda.${if cudaOlder "13.0" then "cuda_nvcc" else "libnvptxcompiler"} or null;
  preInstall = lib.optionalString (cudaOlder "13.0") ''
    mv include/nvPTXCompiler.h .
    rm -rf bin include nvvm nvvm-next
    mkdir include
    mv nvPTXCompiler.h include/
  '';

  meta = {
    description = "APIs which can be used to compile a PTX program into GPU assembly code";
    homepage = "https://docs.nvidia.com/cuda/ptx-compiler-api";
  };
}
