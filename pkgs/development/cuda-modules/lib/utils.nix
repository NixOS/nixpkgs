{ cudaLib, lib }:
{
  /**
    Removes the dots from a string.

    # Type

    ```
    dropDots :: (str :: String) -> String
    ```

    # Inputs

    `str`

    : The string to remove dots from

    # Examples

    :::{.example}
    ## `cudaLib.utils.dropDots` usage examples

    ```nix
    dropDots "1.2.3"
    => "123"
    ```
    :::
  */
  dropDots = lib.replaceStrings [ "." ] [ "" ];

  /**
    Replaces dots in a string with underscores.

    # Type

    ```
    dotsToUnderscores :: (str :: String) -> String
    ```

    # Inputs

    `str`

    : The string for which dots shall be replaced by underscores

    # Examples

    :::{.example}
    ## `cudaLib.utils.dotsToUnderscores` usage examples

    ```nix
    dotsToUnderscores "1.2.3"
    => "1_2_3"
    ```
    :::
  */
  dotsToUnderscores = lib.replaceStrings [ "." ] [ "_" ];

  /**
    Create a versioned attribute name from a version.

    # Type

    ```
    mkVersionedName :: (name :: String) -> (version :: Version) -> String
    ```

    # Inputs

    `name`

    : The name to use

    `version`

    : The version to use

    # Examples

    :::{.example}
    ## `cudaLib.utils.mkVersionedName` usage examples

    ```nix
    mkVersionedName "hello" "1.2.3"
    => "hello_1_2_3"
    ```

    ```nix
    mkVersionedName "cudaPackages" "12.8"
    => "cudaPackages_12_8"
    ```
    :::
  */
  mkVersionedName = name: version: "${name}_${cudaLib.utils.dotsToUnderscores version}";

  /**
    Generates a CUDA variant name from a version.

    # Type

    ```
    mkCudaVariant :: (version :: String) -> String
    ```

    # Inputs

    `version`

    : The version string

    # Examples

    :::{.example}
    ## `cudaLib.utils.mkCudaVariant` usage examples

    ```nix
    mkCudaVariant "11.0"
    => "cuda11"
    ```
    :::
  */
  mkCudaVariant = version: "cuda${lib.versions.major version}";

  /**
    Extracts the major, minor, and patch version from a string.

    # Type

    ```
    majorMinorPatch :: (version :: String) -> String
    ```

    # Inputs

    `version`

    : The version string

    # Examples

    :::{.example}
    ## `cudaLib.utils.majorMinorPatch` usage examples

    ```nix
    majorMinorPatch "11.0.3.4"
    => "11.0.3"
    ```
    :::
  */
  majorMinorPatch = cudaLib.utils.trimComponents 3;

  /**
    Get a version string with no more than than the specified number of components.

    # Type

    ```
    trimComponents :: (numComponents :: Integer) -> (version :: String) -> String
    ```

    # Inputs

    `numComponents`
    : A positive integer corresponding to the maximum number of components to keep

    `version`
    : A version string

    # Examples

    :::{.example}
    ## `cudaLib.utils.trimComponents` usage examples

    ```nix
    trimComponents 1 "1.2.3.4"
    => "1"
    ```

    ```nix
    trimComponents 3 "1.2.3.4"
    => "1.2.3"
    ```

    ```nix
    trimComponents 9 "1.2.3.4"
    => "1.2.3.4"
    ```
    :::
  */
  trimComponents =
    n: v:
    lib.pipe v [
      lib.splitVersion
      (lib.take n)
      (lib.concatStringsSep ".")
    ];

  /**
    Function to generate a URL for something in the redistributable tree.

    # Type

    ```
    mkRedistUrl :: (redistName :: RedistName) -> (relativePath :: NonEmptyStr) -> RedistUrl
    ```

    # Inputs

    `redistName`

    : The name of the redistributable

    `relativePath`

    : The relative path to a file in the redistributable tree
  */
  mkRedistUrl =
    redistName: relativePath:
    lib.concatStringsSep "/" (
      [ cudaLib.data.redistUrlPrefix ]
      ++ (
        if redistName != "tensorrt" then
          [
            redistName
            "redist"
          ]
        else
          [ "machine-learning" ]
      )
      ++ [ relativePath ]
    );

  /**
    Function to generate a string of failed assertions.

    # Type

    ```
    mkFailedAssertionsString
      :: (assertions :: List { assertion :: Bool, message :: String })
      -> String
    ```

    # Inputs

    `assertions`

    : A list of assertions to evaluate

    # Examples

    :::{.example}
    ## `cudaLib.utils.mkFailedAssertionsString` usage examples

    ```nix
    mkFailedAssertionsString [
      { assertion = false; message = "Assertion 1 failed"; }
      { assertion = true; message = "Assertion 2 failed"; }
    ]
    => "\n- Assertion 1 failed"
    ```

    ```nix
    mkFailedAssertionsString [
      { assertion = false; message = "Assertion 1 failed"; }
      { assertion = false; message = "Assertion 2 failed"; }
    ]
    => "\n- Assertion 1 failed\n- Assertion 2 failed"
    ```
    :::
  */
  mkFailedAssertionsString = lib.foldl' (
    failedAssertionsString:
    { assertion, message }:
    failedAssertionsString + lib.optionalString (!assertion) ("\n- " + message)
  ) "";

  /**
    Evaluate assertions and add error context to return value.

    # Type

    ```
    evaluateAssertions
      :: (assertions :: List { assertion :: Bool, message :: String })
      -> Bool
    ```
  */
  evaluateAssertions =
    assertions:
    let
      failedAssertionsString = cudaLib.utils.mkFailedAssertionsString assertions;
    in
    if failedAssertionsString == "" then
      true
    else
      lib.addErrorContext "with failed assertions:${failedAssertionsString}" false;

  /**
    Returns a boolean indicating whether the package is broken as a result of `finalAttrs.passthru.brokenAssertions`,
    optionally logging evaluation warnings for each reason.

    NOTE: This function requires `finalAttrs.passthru.brokenAssertions` to be a list of assertions and
    `finalAttrs.finalPackage.name` to be available.

    # Type

    ```
    mkMetaBroken :: (warn :: Bool) -> (finalAttrs :: AttrSet) -> Bool
    ```

    # Inputs

    `warn`

    : A boolean indicating whether to log warnings

    `finalAttrs`

    : The final attributes of the package
  */
  mkMetaBroken =
    warn: finalAttrs:
    let
      failedAssertionsString = cudaLib.utils.mkFailedAssertionsString finalAttrs.passthru.brokenAssertions;
      hasFailedAssertions = failedAssertionsString != "";
    in
    lib.warnIf (warn && hasFailedAssertions)
      "Package ${finalAttrs.finalPackage.name} is marked as broken due to the following failed assertions:${failedAssertionsString}"
      hasFailedAssertions;

  /**
    Returns a list of bad platforms for a given package if assertsions in `finalAttrs.passthru.platformAssertions` fail,
    optionally logging evaluation warnings for each reason.

    NOTE: This function requires `finalAttrs.passthru.platformAssertions` to be a list of assertions and
    `finalAttrs.finalPackage.name` and `finalAttrs.finalPackage.stdenv` to be available.

    # Type

    ```
    mkMetaBadPlatforms :: (warn :: Bool) -> (finalAttrs :: AttrSet) -> List String
    ```
  */
  mkMetaBadPlatforms =
    warn: finalAttrs:
    let
      failedAssertionsString = cudaLib.utils.mkFailedAssertionsString finalAttrs.passthru.platformAssertions;
      hasFailedAssertions = failedAssertionsString != "";
      finalStdenv = finalAttrs.finalPackage.stdenv;
    in
    lib.warnIf (warn && hasFailedAssertions)
      "Package ${finalAttrs.finalPackage.name} is unsupported on this platform due to the following failed assertions:${failedAssertionsString}"
      (
        lib.optionals hasFailedAssertions (
          lib.unique [
            finalStdenv.buildPlatform.system
            finalStdenv.hostPlatform.system
            finalStdenv.targetPlatform.system
          ]
        )
      );

  /**
    Maps a NVIDIA redistributable system to Nix systems.

    NOTE: This function returns a list of systems because the redistributable systems `"linux-all"` and
    `"source"` can be built on multiple systems.

    NOTE: This function *will* be called by unsupported systems because `cudaPackages` is part of
    `all-packages.nix`, which is evaluated on all systems. As such, we need to handle unsupported
    systems gracefully.

    # Type

    ```
    getNixSystems :: (redistSystem :: RedistSystem) -> [String]
    ```

    # Inputs

    `redistSystem`

    : The NVIDIA redistributable system

    # Examples

    :::{.example}
    ## `cudaLib.utils.getNixSystems` usage examples

    ```nix
    getNixSystems "linux-sbsa"
    => [ "aarch64-linux" ]
    ```

    ```nix
    getNixSystems "linux-aarch64"
    => [ "aarch64-linux" ]
    ```
    :::
  */
  getNixSystems =
    redistSystem:
    if redistSystem == "linux-x86_64" then
      [ "x86_64-linux" ]
    else if redistSystem == "linux-sbsa" || redistSystem == "linux-aarch64" then
      [ "aarch64-linux" ]
    else if redistSystem == "linux-all" || redistSystem == "source" then
      [
        "aarch64-linux"
        "x86_64-linux"
      ]
    else
      [ ];

  /**
    Function to map Nix system to NVIDIA redist arch

    NOTE: We swap out the default `linux-sbsa` redist (for server-grade ARM chips) with the
    `linux-aarch64` redist (which is for Jetson devices) if we're building any Jetson devices.
    Since both are based on aarch64, we can only have one or the other, otherwise there's an
    ambiguity as to which should be used.

    NOTE: This function *will* be called by unsupported systems because `cudaPackages` is part of
    `all-packages.nix`, which is evaluated on all systems. As such, we need to handle unsupported
    systems gracefully.

    # Type

    ```
    getRedistSystem :: (hasJetsonCudaCapability :: Bool) -> (nixSystem :: String) -> String
    ```

    # Inputs

    `hasJetsonCudaCapability`

    : If configured for a Jetson device

    `nixSystem`

    : The Nix system

    # Examples

    :::{.example}
    ## `cudaLib.utils.getRedistSystem` usage examples

    ```nix
    getRedistSystem true "aarch64-linux"
    => "linux-aarch64"
    ```

    ```nix
    getRedistSystem false "aarch64-linux"
    => "linux-sbsa"
    ```
    :::
  */
  getRedistSystem =
    hasJetsonCudaCapability: nixSystem:
    if nixSystem == "x86_64-linux" then
      "linux-x86_64"
    else if nixSystem == "aarch64-linux" then
      if hasJetsonCudaCapability then "linux-aarch64" else "linux-sbsa"
    else
      "unsupported";

  /**
    Returns a boolean indicating whether the provided redistSystem is supported by any of the redist systems.
  */
  redistSystemIsSupported =
    redistSystem: redistSystems:
    lib.findFirst (
      redistSystem':
      redistSystem' == redistSystem || redistSystem' == "linux-all" || redistSystem' == "source"
    ) null redistSystems != null;

  /**
    Returns whether a capability should be built by default for a particular CUDA version.

    Capabilities built by default are baseline, non-Jetson capabilities with relatively recent CUDA support.

    # Type

    ```
    cudaCapabilityIsDefault
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
  cudaCapabilityIsDefault =
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

    # Type

    ```
    cudaCapabilityIsSupported
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
  cudaCapabilityIsSupported =
    cudaMajorMinorVersion: cudaCapabilityInfo:
    let
      lowerBoundSatisfied = lib.versionAtLeast cudaMajorMinorVersion cudaCapabilityInfo.minCudaMajorMinorVersion;
      upperBoundSatisfied =
        cudaCapabilityInfo.maxCudaMajorMinorVersion == null
        || lib.versionAtLeast cudaCapabilityInfo.maxCudaMajorMinorVersion cudaMajorMinorVersion;
    in
    lowerBoundSatisfied && upperBoundSatisfied;

  /**
    Utility function to generate assertions for missing packages.

    Used to mark a package as unsupported if any of its required packages are missing (null).

    Expects a set of attributes.

    Most commonly used in overrides files on a callPackage-provided attribute set of packages.

    NOTE: We typically use platfromAssertions instead of brokenAssertions because the presence of packages set to null
    means evaluation will fail if package attributes are accessed without checking for null first. OfBorg
    evaluation sets allowBroken to true, which means we can't rely on brokenAssertions to prevent evaluation of
    a package with missing dependencies.

    # Type

    ```
    mkMissingPackagesAssertions
      :: (attrs :: AttrSet)
      -> (assertions :: List { assertion :: Bool, message :: String })
    ```

    # Inputs

    `attrs`

    : The attributes to check for null

    # Examples

    :::{.example}
    ## `cudaLib.utils.mkMissingPackagesAssertions` usage examples

    ```nix
    {
      lib,
      libcal ? null,
      libcublas,
      utils,
    }:
    let
      inherit (lib.attrsets) recursiveUpdate;
      inherit (cudaLib.utils) mkMissingPackagesAssertions;
    in
    prevAttrs: {
      passthru = prevAttrs.passthru or { } // {
        platformAssertions =
          prevAttrs.passthru.platformAssertions or [ ]
          ++ mkMissingPackagesAssertions { inherit libcal; };
      };
    }
    ```
    :::
  */
  mkMissingPackagesAssertions = lib.flip lib.pipe [
    # Take the attributes that are null.
    (lib.filterAttrs (_: value: value == null))
    lib.attrNames
    # Map them to assertions.
    (lib.map (name: {
      message = "${name} is available";
      assertion = false;
    }))
  ];

  /**
    Produces a real architecture string from a CUDA capability.

    # Type

    ```
    mkRealArchitecture :: (cudaCapability :: String) -> String
    ```

    # Inputs

    `cudaCapability`

    : The CUDA capability to convert

    # Examples

    :::{.example}
    ## `cudaLib.utils.mkRealArchitecture` usage examples

    ```nix
    mkRealArchitecture "8.9"
    => "sm_89"
    ```

    ```nix
    mkRealArchitecture "10.0a"
    => "sm_100a"
    ```
    :::
  */
  mkRealArchitecture = cudaCapability: "sm_" + cudaLib.utils.dropDots cudaCapability;

  /**
    Produces a virtual architecture string from a CUDA capability.

    # Type

    ```
    mkVirtualArchitecture :: (cudaCapability :: String) -> String
    ```

    # Inputs

    `cudaCapability`

    : The CUDA capability to convert

    # Examples

    :::{.example}
    ## `cudaLib.utils.mkVirtualArchitecture` usage examples

    ```nix
    mkVirtualArchitecture "8.9"
    => "compute_89"
    ```

    ```nix
    mkVirtualArchitecture "10.0a"
    => "compute_100a"
    ```
    :::
  */
  mkVirtualArchitecture = cudaCapability: "compute_" + cudaLib.utils.dropDots cudaCapability;

  /**
    Produces a CMake-compatible CUDA architecture string from a list of CUDA capabilities.

    # Type

    ```
    mkCmakeCudaArchitecturesString :: (cudaCapabilities :: List String) -> String
    ```

    # Inputs

    `cudaCapabilities`

    : The CUDA capabilities to convert

    # Examples

    :::{.example}
    ## `cudaLib.utils.mkCmakeCudaArchitecturesString` usage examples

    ```nix
    mkCmakeCudaArchitecturesString [ "8.9" "10.0a" ]
    => "89;100a"
    ```
    :::
  */
  mkCmakeCudaArchitecturesString = lib.concatMapStringsSep ";" cudaLib.utils.dropDots;

  /**
    Produces a gencode flag from a CUDA capability.

    # Type

    ```
    mkGencodeFlag :: (archPrefix :: String) -> (cudaCapability :: String) -> String
    ```

    # Inputs

    `archPrefix`

    : The architecture prefix to use for the `code` field

    `cudaCapability`

    : The CUDA capability to convert

    # Examples

    :::{.example}
    ## `cudaLib.utils.mkGencodeFlag` usage examples

    ```nix
    mkGencodeFlag "sm" "8.9"
    => "-gencode=arch=compute_89,code=sm_89"
    ```

    ```nix
    mkGencodeFlag "compute" "10.0a"
    => "-gencode=arch=compute_100a,code=compute_100a"
    ```
    :::
  */
  mkGencodeFlag =
    archPrefix: cudaCapability:
    let
      cap = cudaLib.utils.dropDots cudaCapability;
    in
    "-gencode=arch=compute_${cap},code=${archPrefix}_${cap}";

  /**
    Produces an attribute set of useful data and functionality for packaging CUDA software within Nixpkgs.

    # Type

    ```
    formatCapabilities
      :: { cudaCapabilityToInfo :: AttrSet CudaCapability CudaCapabilityInfo
         , cudaCapabilities :: List CudaCapability
         , cudaForwardCompat :: Bool
         }
      -> { cudaCapabilities :: List CudaCapability
         , cudaForwardCompat :: Bool
         , gencode :: List String
         , realArchs :: List String
         , virtualArchs :: List String
         , archNames :: List String
         , archs :: List String
         , gencodeString :: String
         , cmakeCudaArchitecturesString :: String
         }
    ```

    # Inputs

    `cudaCapabilityToInfo`

    : A mapping of CUDA capabilities to their information

    `cudaCapabilities`

    : A list of CUDA capabilities to use

    `cudaForwardCompat`

    : A boolean indicating whether to include the forward compatibility gencode (+PTX) to support future GPU
      generations
  */
  formatCapabilities =
    {
      cudaCapabilityToInfo,
      cudaCapabilities,
      cudaForwardCompat,
    }:
    let
      /**
        The real architectures for the given CUDA capabilities.

        # Type

        ```
        realArchs :: List String
        ```
      */
      realArchs = lib.map cudaLib.utils.mkRealArchitecture cudaCapabilities;

      /**
        The virtual architectures for the given CUDA capabilities.

        These are typically used for forward compatibility, when trying to support an architecture newer than the CUDA
        version allows.

        # Type

        ```
        virtualArchs :: List String
        ```
      */
      virtualArchs = lib.map cudaLib.utils.mkVirtualArchitecture cudaCapabilities;

      /**
        The gencode flags for the given CUDA capabilities.

        # Type

        ```
        gencode :: List String
        ```
      */
      gencode =
        let
          base = lib.map (cudaLib.utils.mkGencodeFlag "sm") cudaCapabilities;
          forward = cudaLib.utils.mkGencodeFlag "compute" (lib.last cudaCapabilities);
        in
        base ++ lib.optionals cudaForwardCompat [ forward ];
    in
    {
      inherit
        cudaCapabilities
        cudaForwardCompat
        gencode
        realArchs
        virtualArchs
        ;

      /**
        The architecture names for the given CUDA capabilities.

        # Type

        ```
        archNames :: List String
        ```
      */
      # E.g. [ "Ampere" "Turing" ]
      archNames = lib.pipe cudaCapabilities [
        (lib.map (cudaCapability: cudaCapabilityToInfo.${cudaCapability}.archName))
        lib.unique
        lib.naturalSort
      ];

      /**
        The architectures for the given CUDA capabilities, including both real and virtual architectures.

        When `cudaForwardCompat` is enabled, the last architecture in the list is used as the forward compatibility architecture.

        # Type

        ```
        archs :: List String
        ```
      */
      # E.g. [ "sm_75" "sm_86" "compute_86" ]
      archs = realArchs ++ lib.optionals cudaForwardCompat [ (lib.last virtualArchs) ];

      /**
        The gencode string for the given CUDA capabilities.

        # Type

        ```
        gencodeString :: String
        ```
      */
      gencodeString = lib.concatStringsSep " " gencode;

      /**
        The CMake-compatible CUDA architectures string for the given CUDA capabilities.

        # Type

        ```
        cmakeCudaArchitecturesString :: String
        ```
      */
      cmakeCudaArchitecturesString = cudaLib.utils.mkCmakeCudaArchitecturesString cudaCapabilities;
    };
}
