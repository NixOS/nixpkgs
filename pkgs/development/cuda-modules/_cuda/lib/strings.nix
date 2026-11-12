{ _cuda, lib }:
let
  cudaLib = _cuda.lib;
in
{
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
    ## `cudaLib.dotsToUnderscores` usage examples

    ```nix
    dotsToUnderscores "1.2.3"
    => "1_2_3"
    ```
    :::
  */
  dotsToUnderscores = lib.replaceStrings [ "." ] [ "_" ];

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
    ## `cudaLib.dropDots` usage examples

    ```nix
    dropDots "1.2.3"
    => "123"
    ```
    :::
  */
  dropDots = lib.replaceStrings [ "." ] [ "" ];

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
         , realArches :: List String
         , virtualArches :: List String
         , archNames :: List String
         , arches :: List String
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
        realArches :: List String
        ```
      */
      realArches = lib.map cudaLib.mkRealArchitecture cudaCapabilities;

      /**
        The virtual architectures for the given CUDA capabilities.

        These are typically used for forward compatibility, when trying to support an architecture newer than the CUDA
        version allows.

        # Type

        ```
        virtualArches :: List String
        ```
      */
      virtualArches = lib.map cudaLib.mkVirtualArchitecture cudaCapabilities;

      /**
        The gencode flags for the given CUDA capabilities.

        # Type

        ```
        gencode :: List String
        ```
      */
      gencode =
        let
          base = lib.map (cudaLib.mkGencodeFlag "sm") cudaCapabilities;
          forward = cudaLib.mkGencodeFlag "compute" (lib.last cudaCapabilities);
        in
        base ++ lib.optionals cudaForwardCompat [ forward ];
    in
    {
      inherit
        cudaCapabilities
        cudaForwardCompat
        gencode
        realArches
        virtualArches
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
        arches :: List String
        ```
      */
      # E.g. [ "sm_75" "sm_86" "compute_86" ]
      arches = realArches ++ lib.optionals cudaForwardCompat [ (lib.last virtualArches) ];

      /**
        The CMake-compatible CUDA architectures string for the given CUDA capabilities.

        # Type

        ```
        cmakeCudaArchitecturesString :: String
        ```
      */
      cmakeCudaArchitecturesString = cudaLib.mkCmakeCudaArchitecturesString cudaCapabilities;

      /**
        The gencode string for the given CUDA capabilities.

        # Type

        ```
        gencodeString :: String
        ```
      */
      gencodeString = lib.concatStringsSep " " gencode;
    };

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
    ## `cudaLib.mkCmakeCudaArchitecturesString` usage examples

    ```nix
    mkCmakeCudaArchitecturesString [ "8.9" "10.0a" ]
    => "89;100a"
    ```
    :::
  */
  mkCmakeCudaArchitecturesString = lib.concatMapStringsSep ";" cudaLib.dropDots;

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
    ## `cudaLib.mkGencodeFlag` usage examples

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
      cap = cudaLib.dropDots cudaCapability;
    in
    "-gencode=arch=compute_${cap},code=${archPrefix}_${cap}";

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
    ## `cudaLib.mkRealArchitecture` usage examples

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
  mkRealArchitecture = cudaCapability: "sm_" + cudaLib.dropDots cudaCapability;

  /**
    Create a versioned attribute name from a version by replacing dots with underscores.

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
    ## `cudaLib.mkVersionedName` usage examples

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
  mkVersionedName = name: version: "${name}_${cudaLib.dotsToUnderscores version}";

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
    ## `cudaLib.mkVirtualArchitecture` usage examples

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
  mkVirtualArchitecture = cudaCapability: "compute_" + cudaLib.dropDots cudaCapability;
}
