{
  lib,
  bootstrapData,
  db,
}:

bootstrapData
// {
  /**
    All CUDA capabilities, sorted by version.

    NOTE: Since the capabilities are sorted by version and architecture/family-specific features are
    appended to the minor version component, the sorted list groups capabilities by baseline feature
    set.

    # Type

    ```
    allSortedCudaCapabilities :: [CudaCapability]
    ```

    # Example

    ```
    allSortedCudaCapabilities = [
      "3.5"
      "3.7"
      "5.0"
      "5.2"
      "6.0"
      "6.1"
      "7.0"
      "7.2"
      "7.5"
      "8.0"
      "8.6"
      "8.7"
      "8.9"
      "9.0"
      "9.0a"
      "10.0"
      "10.0a"
      "10.0f"
      "10.1"
      "10.1a"
      "10.1f"
      "10.3"
      "10.3a"
      "10.3f"
      "10.7"
      "10.7a"
      "10.7f"
      "11.0"
      "11.0a"
      "11.0f"
      "12.0"
      "12.0a"
      "12.0f"
      "12.1"
      "12.1a"
      "12.1f"
    ];
    ```
  */
  allSortedCudaCapabilities = lib.sort lib.versionOlder (lib.attrNames db.cudaCapabilityToInfo);

  /**
    Mapping of CUDA micro-architecture name to capabilities belonging to that micro-architecture.

    # Type

    ```
    cudaArchNameToCapabilities :: AttrSet NonEmptyStr (NonEmptyListOf CudaCapability)
    ```
  */
  cudaArchNameToCapabilities = lib.groupBy (
    cudaCapability: db.cudaCapabilityToInfo.${cudaCapability}.archName
  ) db.allSortedCudaCapabilities;
}
