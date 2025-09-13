{ _cuda, lib }:
{
  /**
    Evaluate assertions and add error context to return value.

    NOTE: No guarantees are made about this function's stability. You may use it at your own risk.

    # Type

    ```
    _evaluateAssertions
      :: (assertions :: List { assertion :: Bool, message :: String })
      -> Bool
    ```
  */
  _evaluateAssertions =
    assertions:
    let
      failedAssertionsString = _cuda.lib._mkFailedAssertionsString assertions;
    in
    if failedAssertionsString == "" then
      true
    else
      lib.addErrorContext "with failed assertions:${failedAssertionsString}" false;

  /**
    Function to generate a string of failed assertions.

    NOTE: No guarantees are made about this function's stability. You may use it at your own risk.

    # Type

    ```
    _mkFailedAssertionsString
      :: (assertions :: List { assertion :: Bool, message :: String })
      -> String
    ```

    # Inputs

    `assertions`

    : A list of assertions to evaluate

    # Examples

    :::{.example}
    ## `_cuda.lib._mkFailedAssertionsString` usage examples

    ```nix
    _mkFailedAssertionsString [
      { assertion = false; message = "Assertion 1 failed"; }
      { assertion = true; message = "Assertion 2 failed"; }
    ]
    => "\n- Assertion 1 failed"
    ```

    ```nix
    _mkFailedAssertionsString [
      { assertion = false; message = "Assertion 1 failed"; }
      { assertion = false; message = "Assertion 2 failed"; }
    ]
    => "\n- Assertion 1 failed\n- Assertion 2 failed"
    ```
    :::
  */
  _mkFailedAssertionsString = lib.foldl' (
    failedAssertionsString:
    { assertion, message }:
    failedAssertionsString + lib.optionalString (!assertion) ("\n- " + message)
  ) "";

  /**
    Utility function to generate assertions for missing packages.

    Used to mark a package as unsupported if any of its required packages are missing (null).

    Expects a set of attributes.

    Most commonly used in overrides files on a callPackage-provided attribute set of packages.

    NOTE: We typically use platfromAssertions instead of brokenAssertions because the presence of packages set to null
    means evaluation will fail if package attributes are accessed without checking for null first. OfBorg evaluation
    sets allowBroken to true, which means we can't rely on brokenAssertions to prevent evaluation of a package with
    missing dependencies.

    NOTE: No guarantees are made about this function's stability. You may use it at your own risk.

    # Type

    ```
    _mkMissingPackagesAssertions
      :: (attrs :: AttrSet)
      -> (assertions :: List { assertion :: Bool, message :: String })
    ```

    # Inputs

    `attrs`

    : The attributes to check for null

    # Examples

    :::{.example}
    ## `_cuda.lib._mkMissingPackagesAssertions` usage examples

    ```nix
    {
      lib,
      libcal ? null,
      libcublas,
      utils,
    }:
    let
      inherit (lib.attrsets) recursiveUpdate;
      inherit (_cuda.lib) _mkMissingPackagesAssertions;
    in
    prevAttrs: {
      passthru = prevAttrs.passthru or { } // {
        platformAssertions =
          prevAttrs.passthru.platformAssertions or [ ]
          ++ _mkMissingPackagesAssertions { inherit libcal; };
      };
    }
    ```
    :::
  */
  _mkMissingPackagesAssertions = lib.flip lib.pipe [
    # Take the attributes that are null.
    (lib.filterAttrs (_: value: value == null))
    lib.attrNames
    # Map them to assertions.
    (lib.map (name: {
      message = "${name} is available";
      assertion = false;
    }))
  ];
}
