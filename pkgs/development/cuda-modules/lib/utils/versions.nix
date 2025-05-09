{ cudaLib, lib }:
{
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
}
