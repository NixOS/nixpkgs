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

  /**
    All architecture-specific CUDA capabilities, sorted by version.

    # Type

    ```
    architectureSpecificCudaCapabilities :: [CudaCapability]
    ```
  */
  architectureSpecificCudaCapabilities = lib.filter (
    cudaCapability: db.cudaCapabilityToInfo.${cudaCapability}.isArchitectureSpecific
  ) db.allSortedCudaCapabilities;

  /**
    All family-specific CUDA capabilities, sorted by version.

    # Type

    ```
    familySpecificCudaCapabilities :: [CudaCapability]
    ```
  */
  familySpecificCudaCapabilities = lib.filter (
    cudaCapability: db.cudaCapabilityToInfo.${cudaCapability}.isFamilySpecific
  ) db.allSortedCudaCapabilities;

  /**
    All Jetson CUDA capabilities, sorted by version.

    # Type

    ```
    jetsonCudaCapabilities :: [CudaCapability]
    ```
  */
  jetsonCudaCapabilities = lib.filter (
    cudaCapability: db.cudaCapabilityToInfo.${cudaCapability}.isJetson
  ) db.allSortedCudaCapabilities;

  /**
    Mapping of CUDA micro-architecture name to Jetson capabilities belonging to that
    micro-architecture.

    This is a Jetson-only subset of `cudaArchNameToCapabilities`: only architectures that have at
    least one Jetson capability appear as keys, and their values contain only the Jetson
    capabilities for that architecture.

    # Type

    ```
    cudaArchNameToJetsonCapabilities :: AttrSet NonEmptyStr (NonEmptyListOf CudaCapability)
    ```
  */
  cudaArchNameToJetsonCapabilities = lib.groupBy (
    cudaCapability: db.cudaCapabilityToInfo.${cudaCapability}.archName
  ) db.jetsonCudaCapabilities;

  /**
    The micro-architecture names that have at least one Jetson capability.

    This is the set of valid `archName` values for `_cuda.lib.cudaCapabilitiesAreJetsonArch`.

    # Type

    ```
    jetsonArchNames :: [String]
    ```
  */
  jetsonArchNames = lib.attrNames db.cudaArchNameToJetsonCapabilities;
}
