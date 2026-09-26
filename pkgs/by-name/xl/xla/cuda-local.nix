# Assemble CUDA, cuDNN, and NCCL layouts from the selected nixpkgs package
# outputs. XLA's Bazel configuration expects toolkit-style directory trees via
# LOCAL_CUDA_PATH, LOCAL_CUDNN_PATH, and LOCAL_NCCL_PATH, rather than Nix's split
# outputs. These layouts let it use packaged dependencies and generate its local
# repositories offline instead of downloading them.
{
  lib,
  symlinkJoin,
  cudaPackages,
}:
let
  # Read only the requested outputs, not propagated inputs (notably older CCCL
  # and cuda_compat). Repeated single-output packages are deduplicated.
  outputs = names: package: map (name: lib.getOutput name package) names;
  components =
    with cudaPackages;
    [
      cuda_nvcc
      cuda_cudart
      cuda_cupti
      libcublas
      libcufft
      libcurand
      libcusolver
      libcusparse
      cuda_nvrtc
      libnvjitlink
      cuda_nvml_dev
      cuda_nvdisasm
      cuda_nvprune
      cuda_profiler_api
      cuda_nvtx
    ]
    ++ lib.optional (lib.versionAtLeast cudaPackages.cuda_nvcc.version "13") cudaPackages.cuda_crt;
  cudaRoots = lib.unique (
    lib.concatMap (outputs [
      "include"
      "lib"
      "bin"
    ]) components
    ++ [
      (lib.getOutput "static" cudaPackages.cuda_cudart)
      (lib.getOutput "stubs" cudaPackages.cuda_nvml_dev)
    ]
  );
in
{
  inherit cudaRoots;
  cuda = symlinkJoin {
    name = "xla-local-cuda";
    paths = cudaRoots;
    # CCCL is supplied separately by XLA's pinned GitHub repository, never by
    # propagated build inputs or a path selected by the standard join order.
    postBuild = ''
      for entry in include/cuda/std include/thrust include/cub include/nv/target; do
        if test -e "$out/$entry"; then
          echo "unexpected CCCL header in local CUDA view: $entry" >&2
          exit 1
        fi
      done
    '';
  };
  cudnn = symlinkJoin {
    name = "xla-local-cudnn";
    paths = lib.unique (outputs [ "include" "lib" ] cudaPackages.cudnn);
  };
  nccl = symlinkJoin {
    name = "xla-local-nccl";
    paths = lib.unique (outputs [ "dev" "lib" ] cudaPackages.nccl);
  };
}
