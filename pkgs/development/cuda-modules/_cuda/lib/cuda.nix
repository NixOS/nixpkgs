{ _cuda, lib }:
let
  jetsonSubset =
    cudaCapabilities: lib.intersectLists _cuda.db.jetsonCudaCapabilities cudaCapabilities;
  jetsonArchSubset =
    archName: cudaCapabilities:
    lib.intersectLists (_cuda.db.cudaArchNameToJetsonCapabilities.${archName} or [ ]) cudaCapabilities;
in
{
  /**
    Returns whether a capability should be built by default for a particular CUDA version.

    Capabilities built by default are baseline, non-Jetson capabilities with relatively recent CUDA support.

    NOTE: No guarantees are made about this function's stability. You may use it at your own risk.

    # Type

    ```
    _cudaCapabilityIsDefault
      :: (cudaMajorMinorVersion :: Version)
      -> (cudaCapabilityInfo :: CudaCapabilityInfo)
      -> Bool
    ```

    # Inputs

    `cudaMajorMinorVersion`

    : The CUDA version to check

    `cudaCapabilityInfo`

    : The capability information to check
  */
  _cudaCapabilityIsDefault =
    cudaMajorMinorVersion: cudaCapabilityInfo:
    let
      recentCapability =
        cudaCapabilityInfo.dontDefaultAfterCudaMajorMinorVersion == null
        || lib.versionAtLeast cudaCapabilityInfo.dontDefaultAfterCudaMajorMinorVersion cudaMajorMinorVersion;
    in
    recentCapability
    && !cudaCapabilityInfo.isJetson
    && !cudaCapabilityInfo.isArchitectureSpecific
    && !cudaCapabilityInfo.isFamilySpecific;

  /**
    Returns whether a capability is supported for a particular CUDA version.

    NOTE: No guarantees are made about this function's stability. You may use it at your own risk.

    # Type

    ```
    _cudaCapabilityIsSupported
      :: (cudaMajorMinorVersion :: Version)
      -> (cudaCapabilityInfo :: CudaCapabilityInfo)
      -> Bool
    ```

    # Inputs

    `cudaMajorMinorVersion`

    : The CUDA version to check

    `cudaCapabilityInfo`

    : The capability information to check
  */
  _cudaCapabilityIsSupported =
    cudaMajorMinorVersion: cudaCapabilityInfo:
    let
      lowerBoundSatisfied = lib.versionAtLeast cudaMajorMinorVersion cudaCapabilityInfo.minCudaMajorMinorVersion;
      upperBoundSatisfied =
        cudaCapabilityInfo.maxCudaMajorMinorVersion == null
        || lib.versionAtLeast cudaCapabilityInfo.maxCudaMajorMinorVersion cudaMajorMinorVersion;
    in
    lowerBoundSatisfied && upperBoundSatisfied;

  /**
    Generates a CUDA variant name from a version.

    NOTE: No guarantees are made about this function's stability. You may use it at your own risk.

    # Type

    ```
    _mkCudaVariant :: (version :: String) -> String
    ```

    # Inputs

    `version`

    : The version string

    # Examples

    :::{.example}
    ## `_cuda.lib._mkCudaVariant` usage examples

    ```nix
    _mkCudaVariant "11.0"
    => "cuda11"
    ```
    :::
  */
  _mkCudaVariant = version: "cuda${lib.versions.major version}";

  /**
    Returns whether a list of CUDA capabilities includes any architecture-specific capability.

    NOTE: No guarantees are made about this function's stability. You may use it at your own risk.

    # Type

    ```
    _cudaCapabilitiesAreArchitectureSpecific :: (cudaCapabilities :: [CudaCapability]) -> Bool
    ```

    # Inputs

    `cudaCapabilities`

    : The list of CUDA capabilities to check
  */
  _cudaCapabilitiesAreArchitectureSpecific =
    cudaCapabilities:
    lib.intersectLists _cuda.db.architectureSpecificCudaCapabilities cudaCapabilities != [ ];

  /**
    Returns whether a list of CUDA capabilities includes any family-specific capability.

    NOTE: No guarantees are made about this function's stability. You may use it at your own risk.

    # Type

    ```
    _cudaCapabilitiesAreFamilySpecific :: (cudaCapabilities :: [CudaCapability]) -> Bool
    ```

    # Inputs

    `cudaCapabilities`

    : The list of CUDA capabilities to check
  */
  _cudaCapabilitiesAreFamilySpecific =
    cudaCapabilities:
    lib.intersectLists _cuda.db.familySpecificCudaCapabilities cudaCapabilities != [ ];

  /**
    Returns whether a list of CUDA capabilities includes any Jetson capability.

    NOTE: No guarantees are made about this function's stability. You may use it at your own risk.

    # Type

    ```
    _cudaCapabilitiesAreJetson :: (cudaCapabilities :: [CudaCapability]) -> Bool
    ```

    # Inputs

    `cudaCapabilities`

    : The list of CUDA capabilities to check
  */
  _cudaCapabilitiesAreJetson = cudaCapabilities: jetsonSubset cudaCapabilities != [ ];

  /**
    Returns whether a list of CUDA capabilities includes any Jetson capability belonging to the
    given micro-architecture.

    NOTE: No guarantees are made about this function's stability. You may use it at your own risk.

    # Type

    ```
    _cudaCapabilitiesAreJetsonArch
      :: (archName :: String)
      -> (cudaCapabilities :: [CudaCapability])
      -> Bool
    ```

    # Inputs

    `archName`

    : The micro-architecture name (e.g. `"Ampere"`, `"Blackwell"`)

    `cudaCapabilities`

    : The list of CUDA capabilities to check
  */
  _cudaCapabilitiesAreJetsonArch =
    archName: cudaCapabilities: jetsonArchSubset archName cudaCapabilities != [ ];

  /**
    Returns the Jetson capabilities within a list of CUDA capabilities.

    # Type

    ```
    cudaCapabilitiesJetsonSubset :: (cudaCapabilities :: [CudaCapability]) -> [CudaCapability]
    ```

    # Inputs

    `cudaCapabilities`

    : The list of CUDA capabilities to filter
  */
  cudaCapabilitiesJetsonSubset = jetsonSubset;

  /**
    Returns whether a list of CUDA capabilities includes any Jetson capability.

    This is the stable public API for `_cudaCapabilitiesAreJetson`.

    # Type

    ```
    cudaCapabilitiesAreJetson :: (cudaCapabilities :: [CudaCapability]) -> Bool
    ```

    # Inputs

    `cudaCapabilities`

    : The list of CUDA capabilities to check
  */
  cudaCapabilitiesAreJetson = cudaCapabilities: jetsonSubset cudaCapabilities != [ ];

  /**
    Returns whether a list of CUDA capabilities includes any Jetson capability belonging to the
    given micro-architecture.

    This is the stable public API for `_cudaCapabilitiesAreJetsonArch`.

    # Type

    ```
    cudaCapabilitiesAreJetsonArch
      :: (archName :: String)
      -> (cudaCapabilities :: [CudaCapability])
      -> Bool
    ```

    # Inputs

    `archName`

    : The micro-architecture name (e.g. `"Ampere"`, `"Blackwell"`)

    `cudaCapabilities`

    : The list of CUDA capabilities to check
  */
  cudaCapabilitiesAreJetsonArch =
    archName: cudaCapabilities: jetsonArchSubset archName cudaCapabilities != [ ];

  /**
    A predicate which, given a package, returns true if the package has a free license or one of NVIDIA's licenses.

    This function is intended to be provided as `config.allowUnfreePredicate` when `import`-ing Nixpkgs.

    # Type

    ```
    allowUnfreeCudaPredicate :: (package :: Package) -> Bool
    ```
  */
  allowUnfreeCudaPredicate =
    let
      cudaLicenseNames = [
        lib.licenses.nvidiaCuda.shortName
      ]
      ++ lib.map (license: license.shortName) (lib.attrValues _cuda.lib.licenses);
    in
    package:
    lib.all (license: license.free || lib.elem (license.shortName or null) cudaLicenseNames) (
      lib.toList package.meta.license
    );
}
