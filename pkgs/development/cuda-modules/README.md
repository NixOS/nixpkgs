# CUDA Modules

> [!NOTE]
> This document is meant to help CUDA maintainers understand the structure of
> the CUDA packages in Nixpkgs. It is not meant to be a user-facing document.
> For a user-facing document, see [the CUDA section of the manual](../../../doc/languages-frameworks/cuda.section.md).

The files in this directory are added (in some way) to the `cudaPackages`
package set by [cuda-packages.nix](../../top-level/cuda-packages.nix).

## Top-level directories

- `_cuda`: Fixed-point used to configure, construct, and extend the CUDA package
    set. This includes NVIDIA manifests.
- `buildRedist`: Contains the logic to build packages using NVIDIA's manifests.
- `packages`: Contains packages which exist in every instance of the CUDA
    package set. These packages are built in a `by-name` fashion.
- `tests`: Contains tests which can be run against the CUDA package set.

Many redistributable packages are in the `packages` directory. Their presence
ensures that, even if a CUDA package set which no longer includes a given package
is being constructed, the attribute for that package will still exist (but refer
to a broken package). This prevents missing attribute errors as the package set
evolves.

## Distinguished packages

Some packages are purposefully not in the `packages` directory. These are packages
which do not make sense for Nixpkgs, require further investigation, or are otherwise
not straightforward to include. These packages are:

- `cuda`:
  - `collectx_bringup`: missing `libssl.so.1.1` and `libcrypto.so.1.1`; not sure how
    to provide them or what the package does.
  - `cuda_sandbox_dev`: unclear on purpose.
  - `driver_assistant`: we don't use the drivers from the CUDA releases; irrelevant.
  - `mft_autocomplete`: unsure of purpose; contains FHS paths.
  - `mft_oem`: unsure of purpose; contains FHS paths.
  - `mft`: unsure of purpose; contains FHS paths.
  - `nvidia_driver`: we don't use the drivers from the CUDA releases; irrelevant.
  - `nvlsm`: contains FHS paths/NVSwitch and NVLINK software
  - `libnvidia_nscq`: NVSwitch software
  - `libnvsdm`: NVSwitch software
- `cublasmp`:
  - `libcublasmp`: `nvshmem` isnt' packaged.
- `cudnn`:
  - `cudnn_samples`: requires FreeImage, which is abandoned and not packaged.

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
