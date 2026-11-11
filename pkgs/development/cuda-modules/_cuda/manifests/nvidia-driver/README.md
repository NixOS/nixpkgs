# nvidia-driver

Link: <https://developer.download.nvidia.com/compute/nvidia-driver/redist/>

Requirements: <https://docs.nvidia.com/deploy/cuda-compatibility/>

Starting with CUDA 13.4, NVIDIA no longer lists `cuda_compat` in the CUDA redistributable manifest, and publishes it
under the `nvidia-driver` redistributable directory instead. The driver manifests (e.g. `redistrib_615.71.10.json`)
do not list it either, so these manifests are made by hand and only contain `cuda_compat`. They are named after the
driver version, and each archive is built for a single CUDA release, recorded as its `cuda_variant`.

Construct an entry from the archive's relative path, e.g.
`cuda_compat/linux-x86_64/cuda_compat-linux-x86_64-615.71.10_cuda13.4-archive.tar.xz`:

```console
$ url=https://developer.download.nvidia.com/compute/nvidia-driver/redist/cuda_compat/linux-x86_64/cuda_compat-linux-x86_64-615.71.10_cuda13.4-archive.tar.xz
$ path="$(nix store prefetch-file --json "$url" | jq -r .storePath)"
$ sha256sum "$path"; md5sum "$path"; stat -c %s "$path"
```
