{
  buildRedist,
  cudaAtLeast,
  cudaOlder,
  lib,
  fetchpatch,
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

  patches = lib.optionals (cudaAtLeast "12.9" && cudaOlder "13.0") [
    # Fix missing _CCCL_PP_SPLICE_WITH_IMPL20 in preprocessor.h
    # https://github.com/NVIDIA/cccl/issues/4967
    # https://github.com/NVIDIA/cccl/pull/4972
    (fetchpatch {
      name = "fix-missing-_CCCL_PP_SPLICE_WITH_IMPL20";
      url = "https://github.com/NVIDIA/cccl/commit/2c2276d8b19d737cb16811ce2eb761030f472e60.patch";
      stripLen = 1;
      hash = "sha256-hYfMFsd7Y8CwuNGaPYG6uEB+lg1TmWSIIU5ToVMULKY=";
    })
  ];

  # NVIDIA, in their wisdom, expect CCCL to be a directory inside include.
  # https://github.com/NVIDIA/cutlass/blob/087c84df83d254b5fb295a7a408f1a1d554085cf/CMakeLists.txt#L773
  postInstall = lib.optionalString (cudaAtLeast "13.0") ''
    nixLog "creating alias for ''${!outputInclude:?}/include/cccl"
    ln -srv "''${!outputInclude:?}/include" "''${!outputInclude:?}/include/cccl"
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
