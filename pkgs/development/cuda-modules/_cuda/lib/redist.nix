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

    NOTE: We swap out the default `linux-sbsa` redist (for server-grade ARM chips) with the `linux-aarch64` redist
    (which is for Jetson devices) if we're building any Jetson devices. Since both are based on aarch64, we can only
    have one or the other, otherwise there's an ambiguity as to which should be used.

    NOTE: This function *will* be called by unsupported systems because `cudaPackages` is evaluated on all systems. As
    such, we need to handle unsupported systems gracefully.

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
    ## `cudaLib.getRedistSystem` usage examples

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
