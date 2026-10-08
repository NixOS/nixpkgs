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
    Generates CUDA variant names from a version.

    NOTE: No guarantees are made about this function's stability. You may use it at your own risk.

    # Type

    ```
    _mkCudaVariants :: (version :: String) -> [ String ]
    ```

    # Inputs

    `version`

    : The version string

    # Examples

    :::{.example}
    ## `_cuda.lib._mkCudaVariants` usage examples

    ```nix
    _mkCudaVariants "13.2.2"
    => [ "cuda13.2.2" "cuda13.2" "cuda13" ]
    ```
    :::
  */
  _mkCudaVariants =
    cudaMajorMinorPatchVersion:
    lib.map (f: "cuda" + (f cudaMajorMinorPatchVersion)) [
      lib.id
      lib.versions.majorMinor
      lib.versions.major
    ];

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
      cudaLicenses = [
        lib.licenses.nvidiaCuda
        lib.licenses.nvidiaCudaRedist
        lib.licenses.nvidiaCudnn
        lib.licenses.nvidiaCusparse_lt
        lib.licenses.nvidiaCutensor
        lib.licenses.nvidiaCutlassDsl
        lib.licenses.nvidiaTensorrt
        lib.licenses.nvidiaMath_sdk_sla
        lib.licenses.nvidiaCudaRedist
      ];
      cudaLicenseNames = lib.map (license: license.shortName) cudaLicenses;
    in
    package:
    # new compound licenses
    if lib.isAttrs package.meta.license && lib.hasAttr "licenseType" package.meta.license then
      lib.licenses.evaluateProperty (
        license: (license.free or false) || lib.elem license cudaLicenses
      ) true (package.meta.license or [ ])
    else
      # old license list
      lib.all (
        license: (license.free or false) || lib.elem (license.shortName or null) cudaLicenseNames
      ) (lib.toList package.meta.license);
}
