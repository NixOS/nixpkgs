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
- `cublasmp`:
  - `libcublasmp`: `nvshmem` isn't packaged.
- `cudnn`:
  - `cudnn_samples`: requires FreeImage, which is abandoned and not packaged.

> [!NOTE]
>
> When packaging redistributables, prefer `autoPatchelfIgnoreMissingDeps` to providing
> paths to stubs with `extraAutoPatchelfLibs`; the stubs are meant to be used for
> projects where linking against libraries available only at runtime is unavoidable.

### CUDA Compatibility

[CUDA Compatibility](https://docs.nvidia.com/deploy/cuda-compatibility/),
available as `cudaPackages.cuda_compat`, provides user-mode driver components
for running newer CUDA applications with an older host driver, subject to
NVIDIA's hardware and driver compatibility requirements. Availability depends
on the selected release and platform: the CUDA 13.3 manifests include x86_64
Linux and AArch64 SBSA archives, while CUDA 12.9 provides a Jetson archive.

The package is disabled by default. Set `config.enableCudaDriverCompat = true`
when the host driver is older than the compatibility driver for the selected
CUDA release. This does not make an unavailable archive supported, and it is
independent of `config.cudaForwardCompat`, which controls embedded PTX for
future GPUs. The compatibility libraries still require the installed kernel
driver and may need other libraries from the host's driver installation.

#### CUDA Compat with Nix

When `cuda_compat.meta.available` is true, `buildRedist` adds
`autoAddCudaCompatRunpath` after `autoAddDriverRunpath`. Both hooks prepend
runtime paths, so the compatibility driver takes precedence over the host
driver search path. The compatibility package itself is excluded to avoid a
dependency cycle. Null, disabled, and unavailable compatibility packages leave
only the host driver search path.

CUDART publishes the same ordered paths in `driverRunpath`. Its pkg-config
files and packaged NVCC use that value for links outside stdenv, keeping the
runtime driver ahead of the link-time stub. The review fixture accepts
`enableCudaDriverCompat = true` to exercise the existing `nvcc-runtime` tests
with this optional dependency enabled.
