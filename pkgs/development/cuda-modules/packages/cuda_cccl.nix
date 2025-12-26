{
  buildRedist,
  cudaAtLeast,
  lib,
}:
buildRedist {
  redistName = "cuda";
  pname = "cuda_cccl";

  # Restrict header-only packages to a single output.
  # Also, when using multiple outputs (i.e., `out`, `dev`, and `include`), something isn't being patched correctly,
  # so libnvshmem fails to build, complaining about being unable to find the thrust include directory. This is likely
  # because the `dev` output contains the CMake configuration and is written to assume it will share a parent
  # directory with the include directory rather than be in a separate output.
  outputs = [ "out" ];

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
