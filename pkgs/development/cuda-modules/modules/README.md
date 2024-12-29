# Modules

Modules as they are used in `modules` exist primarily to check the shape and
content of CUDA redistributable and feature manifests. They are ultimately meant
to reduce the repetitive nature of repackaging CUDA redistributables.

Building most redistributables follows a pattern of a manifest indicating which
packages are available at a location, their versions, and their hashes. To avoid
creating builders for each and every derivation, modules serve as a way for us
to use a single `genericManifestBuilder` to build all redistributables.

## `generic`

The modules in `generic` are reusable components meant to check the shape and
content of NVIDIA's CUDA redistributable manifests, our feature manifests (which
are derived from NVIDIA's manifests), or hand-crafted Nix expressions describing
available packages. They are used by the `genericManifestBuilder` to build CUDA
redistributables.

Generally, each package which relies on manifests or Nix release expressions
will create an alias to the relevant generic module. For example, the [module
for CUDNN](./cudnn/default.nix) aliases the generic module for release
expressions, while the [module for CUDA redistributables](./cuda/default.nix)
aliases the generic module for manifests.

Alternatively, additional fields or values may need to be configured to account
for the particulars of a package. For example, while the release expressions for
[CUDNN](./cudnn/releases.nix) and [TensorRT](./tensorrt/releases.nix) are very
close, they differ slightly in the fields they have. The [module for
CUDNN](./modules/cudnn/default.nix) is able to use the generic module for
release expressions, while the [module for
TensorRT](./modules/tensorrt/default.nix) must add additional fields to the
generic module.

### `manifests`

The modules in `generic/manifests` define the structure of NVIDIA's CUDA
redistributable manifests and our feature manifests.

NVIDIA's redistributable manifests are retrieved from their web server, while
the feature manifests are produced by
[`cuda-redist-find-features`](https://github.com/connorbaker/cuda-redist-find-features).

### `releases`

The modules in `generic/releases` define the structure of our hand-crafted Nix
expressions containing information necessary to download and repackage CUDA
redistributables. These expressions are created when NVIDIA-provided manifests
are unavailable or otherwise unusable. For example, though CUDNN has manifests,
a bug in NVIDIA's CI/CD causes manifests for different versions of CUDA to use
the same name, which leads to the manifests overwriting each other.

### `types`

The modules in `generic/types` define reusable types used in both
`generic/manifests` and `generic/releases`.
