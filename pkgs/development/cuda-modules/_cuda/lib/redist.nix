{ _cuda, lib }:
{
  /**
    Returns a boolean indicating whether the provided redist system is supported by any of the provided redist systems.

    NOTE: No guarantees are made about this function's stability. You may use it at your own risk.

    # Type

    ```
    _redistSystemIsSupported
      :: (redistSystem :: RedistSystem)
      -> (redistSystems :: List RedistSystem)
      -> Bool
    ```

    # Inputs

    `redistSystem`

    : The redist system to check

    `redistSystems`

    : The list of redist systems to check against

    # Examples

    :::{.example}
    ## `cudaLib._redistSystemIsSupported` usage examples

    ```nix
    _redistSystemIsSupported "linux-x86_64" [ "linux-x86_64" ]
    => true
    ```

    ```nix
    _redistSystemIsSupported "linux-x86_64" [ "linux-aarch64" ]
    => false
    ```

    ```nix
    _redistSystemIsSupported "linux-x86_64" [ "linux-aarch64" "linux-x86_64" ]
    => true
    ```

    ```nix
    _redistSystemIsSupported "linux-x86_64" [ "linux-aarch64" "linux-all" ]
    => true
    ```
    :::
  */
  _redistSystemIsSupported =
    redistSystem: redistSystems:
    lib.findFirst (
      redistSystem':
      redistSystem' == redistSystem || redistSystem' == "linux-all" || redistSystem' == "source"
    ) null redistSystems != null;

  /**
    Maps a NVIDIA redistributable system to Nix systems.

    NOTE: This function returns a list of systems because the redistributable systems `"linux-all"` and `"source"` can
    be built on multiple systems.

    NOTE: This function *will* be called by unsupported systems because `cudaPackages` is evaluated on all systems. As
    such, we need to handle unsupported systems gracefully.

    # Type

    ```
    getNixSystems :: (redistSystem :: RedistSystem) -> [String]
    ```

    # Inputs

    `redistSystem`

    : The NVIDIA redistributable system

    # Examples

    :::{.example}
    ## `cudaLib.getNixSystems` usage examples

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
    Maps a Nix system to a NVIDIA redistributable system.

    NOTE: Certain Nix systems can map to multiple NVIDIA redistributable systems. In particular, ARM systems can map to
    either `linux-sbsa` (for server-grade ARM chips) or `linux-aarch64` (for Jetson devices). Complicating matters
    further, as of CUDA 13.0, Jetson Thor devices use `linux-sbsa` instead of `linux-aarch64`. (It is unknown whether
    NVIDIA plans to make the Orin series use `linux-sbsa` as well for the CUDA 13.0 release.)

    NOTE: This function *will* be called by unsupported systems because `cudaPackages` is evaluated on all systems. As
    such, we need to handle unsupported systems gracefully.

    NOTE: This function does not check whether the provided CUDA capabilities are valid for the given CUDA version.
    The heavy validation work to ensure consistency of CUDA capabilities is performed by backendStdenv.

    # Type

    ```
    getRedistSystem ::
      { cudaCapabilities :: List String
      , cudaMajorMinorVersion :: String
      , system :: String
      }
      -> String
    ```

    # Inputs

    `cudaCapabilities`

    : The list of CUDA capabilities to build GPU code for

    `cudaMajorMinorVersion`

    : The major and minor version of CUDA (e.g. "12.6")

    `system`

    : The Nix system

    # Examples

    :::{.example}
    ## `cudaLib.getRedistSystem` usage examples

    ```nix
    getRedistSystem {
      cudaCapabilities = [ "8.7" ];
      cudaMajorMinorVersion = "12.6";
      system = "aarch64-linux";
    }
    => "linux-aarch64"
    ```

    ```nix
    getRedistSystem {
      cudaCapabilities = [ "11.0" ];
      cudaMajorMinorVersion = "13.0";
      system = "aarch64-linux";
    }
    => "linux-sbsa"
    ```

    ```nix
    getRedistSystem {
      cudaCapabilities = [ "8.0" "8.9" ];
      cudaMajorMinorVersion = "12.6";
      system = "aarch64-linux";
    }
    => "linux-sbsa"
    ```
    :::
  */
  getRedistSystem =
    {
      cudaCapabilities,
      cudaMajorMinorVersion,
      system,
    }:
    if system == "x86_64-linux" then
      "linux-x86_64"
    else if system == "aarch64-linux" then
      # If all the Jetson devices are at least 10.1 (Thor, CUDA 12.9; CUDA 13.0 and later use 11.0 for Thor), then
      # we've got SBSA.
      if
        lib.all (
          cap: _cuda.db.cudaCapabilityToInfo.${cap}.isJetson -> lib.versionAtLeast cap "10.1"
        ) cudaCapabilities
      then
        "linux-sbsa"
      # Otherwise we've got some Jetson devices older than Thor and need to use linux-aarch64.
      else
        "linux-aarch64"
    else
      "unsupported";

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
      [ _cuda.db.redistUrlPrefix ]
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
}
