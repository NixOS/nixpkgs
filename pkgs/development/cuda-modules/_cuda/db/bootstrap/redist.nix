{
  /**
    A list of redistributable names to use in creation of the `redistName` option type.

    # Type

    ```
    redistNames :: [String]
    ```
  */
  redistNames = [
    "cublasmp"
    "cuda"
    "cudnn"
    "cudss"
    "cuquantum"
    "cusolvermp"
    "cusparselt"
    "cutensor"
    "nppplus"
    "nvcomp"
    # "nvidia-driver",  # NOTE: Some of the earlier manifests don't follow our scheme.
    "nvjpeg2000"
    "nvpl"
    "nvtiff"
    "tensorrt" # NOTE: not truly a redist; uses different naming convention
  ];

  /**
    A list of redistributable systems to use in creation of the `redistSystem` option type.

    # Type

    ```
    redistSystems :: [String]
    ```
  */
  redistSystems = [
    "linux-aarch64"
    "linux-all" # Taken to mean all other linux systems
    "linux-sbsa"
    "linux-x86_64"
    "source" # Source-agnostic platform
  ];

  /**
    The prefix of the URL for redistributable files.

    # Type

    ```
    redistUrlPrefix :: String
    ```
  */
  redistUrlPrefix = "https://developer.download.nvidia.com/compute";
}
