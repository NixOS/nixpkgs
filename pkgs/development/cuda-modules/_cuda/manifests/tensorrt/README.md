# tensorrt

Requirements: <https://docs.nvidia.com/deeplearning/tensorrt/latest/getting-started/support-matrix.html#support-matrix>

These redistributable manifests are made by hand to allow TensorRT to be packaged with the same functionality the other NVIDIA redistributable libraries are packaged with.

Only available from 10.0.0 and onwards, which is when NVIDIA stopped putting them behind a login wall.

You can find them at: <https://github.com/NVIDIA/TensorRT?tab=readme-ov-file#optional---if-not-using-tensorrt-container-specify-the-tensorrt-ga-release-build-path>.

Construct entries using the provider `helper.bash` script.

As an example:

```console
$ ./tensorrt/helper.bash 12.5 10.2.0.19 windows-x86_64
main: storePath: /nix/store/l2hq83ihj3bcm4z836cz2dw3ilkhwrpy-TensorRT-10.2.0.19.Windows.win10.cuda-12.5.zip
{
  "windows-x86_64": {
    "cuda12": {
      "md5": "70282ec501c9e395a3ffdd0d2baf9d95",
      "relative_path": "tensorrt/10.2.0/zip/TensorRT-10.2.0.19.Windows.win10.cuda-12.5.zip",
      "sha256": "4a9c6e279fd36559551a6d88e37d835db5ebdc950246160257b0b538960e57fa",
      "size": "1281366141"
    }
  }
}
```

I set the `release_date` to the date of the corresponding release on their GitHub: <https://github.com/NVIDIA/TensorRT/releases>.
