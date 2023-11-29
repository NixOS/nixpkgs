# Cuda modules

> [!NOTE]
> This document is meant to help CUDA maintainers understand the structure of
> the CUDA packages in Nixpkgs. It is not meant to be a user-facing document.
> For a user-facing document, see [the CUDA section of the manual](../../../doc/languages-frameworks/cuda.section.md).

The files in this directory are added (in some way) to the `cudaPackages`
package set by [cuda-packages.nix](../../top-level/cuda-packages.nix).

## Top-level files

Top-level nix files are included in the initial creation of the `cudaPackages`
scope. These are typically required for the creation of the finalized
`cudaPackages` scope:

- `backend-stdenv.nix`: Standard environment for CUDA packages.
- `flags.nix`: Flags set, or consumed by, NVCC in order to build packages.
- `gpus.nix`: A list of supported NVIDIA GPUs.
- `nvcc-compatibilities.nix`: NVCC releases and the version range of GCC/Clang
    they support.

## Top-level directories

- `cuda`: CUDA redistributables! Provides extension to `cudaPackages` scope.
- `cudatoolkit`: monolothic CUDA Toolkit run-file installer. Provides extension
    to `cudaPackages` scope.
- `cudnn`: NVIDIA cuDNN library.
- `cutensor`: NVIDIA cuTENSOR library.
- `generic-builders`:
  - Contains a builder `manifest.nix` which operates on the `Manifest` type
      defined in `modules/generic/manifests`. Most packages are built using this
      builder.
  - Contains a builder `multiplex.nix` which leverages the Manifest builder. In
      short, the Multiplex builder adds multiple versions of a single package to
      single instance of the CUDA Packages package set. It is used primarily for
      packages like `cudnn` and `cutensor`.
- `modules`: Nixpkgs modules to check the shape and content of CUDA
    redistributable and feature manifests. These modules additionally use shims
    provided by some CUDA packages to allow them to re-use the
    `genericManifestBuilder`, even if they don't have manifest files of their
    own. `cudnn` and `tensorrt` are examples of packages which provide such
    shims. These modules are further described in the
    [Modules](./modules/README.md) documentation.
- `nccl`: NVIDIA NCCL library.
- `nccl-tests`: NVIDIA NCCL tests.
- `saxpy`: Example CMake project that uses CUDA.
- `setup-hooks`: Nixpkgs setup hooks for CUDA.
- `tensorrt`: NVIDIA TensorRT library.
