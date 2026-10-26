{ _cuda, lib }:
{
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
}
