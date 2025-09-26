# CUDA Modules

> [!NOTE]
> This document is meant to help CUDA maintainers understand the structure of
> the CUDA packages in Nixpkgs. It is not meant to be a user-facing document.
> For a user-facing document, see [the CUDA section of the manual](../../../doc/languages-frameworks/cuda.section.md).

The files in this directory are added (in some way) to the `cudaPackages`
package set by [cuda-packages.nix](../../top-level/cuda-packages.nix).

## Top-level directories

- `cuda`: CUDA redistributables! Provides extension to `cudaPackages` scope.
- `cudatoolkit`: monolithic CUDA Toolkit run-file installer. Provides extension
    to `cudaPackages` scope.
- `cudnn`: NVIDIA cuDNN library.
- `cutensor`: NVIDIA cuTENSOR library.
- `fixups`: Each file or directory (excluding `default.nix`) should contain a
    `callPackage`-able expression to be provided to the `overrideAttrs` attribute
    of a package produced by the generic manifest builder.
    These fixups are applied by `pname`, so packages with multiple versions
    (e.g., `cudnn`, `cudnn_8_9`, etc.) all share a single fixup function
    (i.e., `fixups/cudnn.nix`).
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
- `packages`: Contains packages which exist in every instance of the CUDA
    package set. These packages are built in a `by-name` fashion.
- `setup-hooks`: Nixpkgs setup hooks for CUDA.
- `tensorrt`: NVIDIA TensorRT library.

## Distinguished packages

### CUDA Compatibility

[CUDA Compatibility](https://docs.nvidia.com/deploy/cuda-compatibility/),
available as `cudaPackages.cuda_compat`, is a component which makes it possible
to run applications built against a newer CUDA toolkit (for example CUDA 12) on
a machine with an older CUDA driver (for example CUDA 11), which isn't possible
out of the box. At the time of writing, CUDA Compatibility is only available on
the Nvidia Jetson architecture, but Nvidia might release support for more
architectures in the future.

As CUDA Compatibility strictly increases the range of supported applications, we
try our best to enable it by default on supported platforms.

#### Functioning

`cuda_compat` simply provides a new `libcuda.so` (and associated variants) that
needs to be used in place of the default CUDA driver's `libcuda.so`. However,
the other shared libraries of the default driver must still be accessible:
`cuda_compat` isn't a complete drop-in replacement for the driver (and that's
the point, otherwise, it would just be a newer driver).

Nvidia's recommendation is to set `LD_LIBRARY_PATH` to point to `cuda_compat`'s
driver. This is fine for a manual, one-shot usage, but in general setting
`LD_LIBRARY_PATH` is a red flag. This is global state which short-circuits most
of other dynamic library resolution mechanisms and can break things in
non-obvious ways, especially with other Nix-built software.

#### CUDA Compat with Nix

Since `cuda_compat` is a known derivation, the easy way to do this in Nix would
be to add `cuda_compat` as a dependency of CUDA libraries and applications and
let Nix do its magic by filling the `DT_RUNPATH` fields. However,
`cuda_compat` itself depends on `libnvrm_mem` and `libnvrm_gpu` which are loaded
dynamically at runtime from `/run/opengl-driver`. This doesn't please the Nix
sandbox when building, which can't find those (a second minor issue is that
`addOpenGLRunpathHook` prepends the `/run/opengl-driver` path, so that would
still take precedence).

The current solution is to do something similar to `addOpenGLRunpathHook`: the
`addCudaCompatRunpathHook` prepends to the path to `cuda_compat`'s `libcuda.so`
to the `DT_RUNPATH` of whichever package includes the hook as a dependency, and
we include the hook by default for packages in `cudaPackages` (by adding it as a
inputs in `genericManifestBuilder`). We also make sure it's included after
`addOpenGLRunpathHook`, so that it appears _before_ in the `DT_RUNPATH` and
takes precedence.
