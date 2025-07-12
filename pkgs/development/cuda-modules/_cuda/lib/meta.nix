{ _cuda, lib }:
{
  /**
    Returns a list of bad platforms for a given package if assertsions in `finalAttrs.passthru.platformAssertions`
    fail, optionally logging evaluation warnings for each reason.

    NOTE: No guarantees are made about this function's stability. You may use it at your own risk.

    NOTE: This function requires `finalAttrs.passthru.platformAssertions` to be a list of assertions and
    `finalAttrs.finalPackage.name` and `finalAttrs.finalPackage.stdenv` to be available.

    # Type

    ```
    _mkMetaBadPlatforms :: (warn :: Bool) -> (finalAttrs :: AttrSet) -> List String
    ```
  */
  _mkMetaBadPlatforms =
    warn: finalAttrs:
    let
      failedAssertionsString = _cuda.lib._mkFailedAssertionsString finalAttrs.passthru.platformAssertions;
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
    Returns a boolean indicating whether the package is broken as a result of `finalAttrs.passthru.brokenAssertions`,
    optionally logging evaluation warnings for each reason.

    NOTE: No guarantees are made about this function's stability. You may use it at your own risk.

    NOTE: This function requires `finalAttrs.passthru.brokenAssertions` to be a list of assertions and
    `finalAttrs.finalPackage.name` to be available.

    # Type

    ```
    _mkMetaBroken :: (warn :: Bool) -> (finalAttrs :: AttrSet) -> Bool
    ```

    # Inputs

    `warn`

    : A boolean indicating whether to log warnings

    `finalAttrs`

    : The final attributes of the package
  */
  _mkMetaBroken =
    warn: finalAttrs:
    let
      failedAssertionsString = _cuda.lib._mkFailedAssertionsString finalAttrs.passthru.brokenAssertions;
      hasFailedAssertions = failedAssertionsString != "";
    in
    lib.warnIf (warn && hasFailedAssertions)
      "Package ${finalAttrs.finalPackage.name} is marked as broken due to the following failed assertions:${failedAssertionsString}"
      hasFailedAssertions;
}
