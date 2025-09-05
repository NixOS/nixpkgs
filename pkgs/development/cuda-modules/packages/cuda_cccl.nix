{
  buildRedist,
  cudaAtLeast,
  lib,
}:
buildRedist {
  redistName = "cuda";
  pname = "cuda_cccl";

  outputs = [
    "out"
    "dev"
    "include"
  ];

  prePatch = lib.optionalString (cudaAtLeast "13.0") ''
    nixLog "removing top-level $PWD/include/nv directory"
    rm -rfv "$PWD/include/nv"
    nixLog "un-nesting top-level $PWD/include/cccl directory"
    mv -v "$PWD/include/cccl"/* "$PWD/include/"
    nixLog "removing empty $PWD/include/cccl directory"
    rmdir -v "$PWD/include/cccl"
  '';

  meta = {
    description = "Building blocks that make it easier to write safe and efficient CUDA C++ code";
    longDescription = ''
      The goal of CCCL is to provide CUDA C++ developers with building blocks that make it easier to write safe and
      efficient code.
    '';
    homepage = "https://github.com/NVIDIA/cccl";
    changelog = "https://github.com/NVIDIA/cccl/releases";
  };
}
