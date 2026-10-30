# cublasdx

Link: <https://developer.nvidia.com/cublasdx-downloads>

Requirements: <https://docs.nvidia.com/cuda/mathdx/release_notes.html>

NVIDIA publishes MathDx (cuBLASDx, cuFFTDx, cuRANDDx, cuSolverDx, and nvCOMPDx) under the `cublasdx` redistributable
directory, but without a redistributable manifest, so these manifests are made by hand. Each release supports a single
CUDA major version with one archive for all platforms, which is listed under `linux-all`: 25.06.1 is the last release
for CUDA 12 (12.6.3 and newer), and 26.x supports CUDA 13.0 and newer.

Construct an entry from the archive's relative path, e.g. `cublasdx/cuda13/nvidia-mathdx-26.10.0-cuda13.tar.gz`:

```console
$ url=https://developer.download.nvidia.com/compute/cublasdx/redist/cublasdx/cuda13/nvidia-mathdx-26.10.0-cuda13.tar.gz
$ path="$(nix store prefetch-file --json "$url" | jq -r .storePath)"
$ sha256sum "$path"; md5sum "$path"; stat -c %s "$path"
```
