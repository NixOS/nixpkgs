{ lib }:
rec {
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
    ## `_cuda.lib.majorMinorPatch` usage examples

    ```nix
    majorMinorPatch "11.0.3.4"
    => "11.0.3"
    ```
    :::
  */
  majorMinorPatch = trimComponents 3;

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
    ## `_cuda.lib.trimComponents` usage examples

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
  trimComponents = n: v: lib.concatStringsSep "." (quantizeVersion n v);

  /**
    ```nix
    quantizeVersion 2 "1.2.3"
    => [ "1" "2" ]
    ```
  */
  quantizeVersion = components: version: lib.take components (lib.versions.splitVersion version);

  /*
    ∷ VersionString → Bool

    Test equality of versions quantized to highest common precision.

    ```nix
    matchQuantized "12" "12.2"
    => true
    ```

    ```nix
    matchQuantized "12" "11.8"
    => false
    ```
  */
  matchQuantized =
    v1: v2:
    let
      components1 = lib.length (lib.versions.splitVersion v1);
      components2 = lib.length (lib.versions.splitVersion v2);
      components = lib.min components1 components2;
    in
    quantizeVersion components v1 == quantizeVersion components v2;

  /*
    ∷ (VersionString ⇒ T) → VersionString → T

    ```nix
    selectQuantized { "11.8" = "11.8.0"; "12.0" = "12.0.1"; } "12"
    => "12.0.1"
    ```

    ```nix
    selectQuantized { "11.8" = "11.8.0"; "12.0" = "12.0.1"; } "13"
    => null
    ```
  */
  selectQuantized =
    versions: versionQuery:
    assert builtins.isString versionQuery;
    assert builtins.isAttrs versions;
    lib.last (
      [ null ]
      ++ lib.attrValues (lib.filterAttrs (version: _: matchQuantized versionQuery version) versions)
    );
}
