{ _cuda, lib }:
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
