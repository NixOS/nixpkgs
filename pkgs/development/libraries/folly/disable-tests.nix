{ lib }:

let
  /* Disable one or more of folly's tests.

     Type: disableTests :: AttrSet (Either Bool String) -> String

     disableTests returns a script which patches folly's source code.

     To disable a single test, give a pair of file name (key) and a the test's
     name (wrapped in a list) (value):
       disableTests { "path/to/suite.cpp" = [ "name_of_test" ]; }

     To disable a suite of tests, give a pair of the test suite's name (as
     specified in CMakeLists.txt) (key) and true (value):
       disableTests { "name_of_suite" = true; }
  */
  disableTests = testsToDisable:
    lib.concatStringsSep "\n" (lib.concatLists (lib.mapAttrsToList
      (suite: value:
        if builtins.isBool value
        then
          lib.optionals value [ (disableTestSuite suite) ]
        else
          assert assertMsg (builtins.isList value)
            "value for ${suite} should be a list or a boolean; got a ${builtins.typeOf value}";
            map (testName: disableOneTest suite testName) value)
      testsToDisable));

  /* Type: disableOneTest :: String -> String -> String
  */
  disableOneTest = path: testName:
    let
      original = ", ${testName}) {";
      replacement = ", DISABLED_${testName}) {";
    in
      "substituteInPlace ${escapeShellArg path} --replace ${escapeShellArg original} ${escapeShellArg replacement}";

  /* Type: disableTestSuite :: String -> String
  */
  disableTestSuite = suite:
    let
      original = "TEST ${suite}";
      replacement = "TEST ${suite} BROKEN";
    in
      "substituteInPlace CMakeLists.txt --replace ${escapeShellArg original} ${escapeShellArg replacement}";

  checkDisableTests = x:
    assert disableOneTest "file"  "test"
      == "substituteInPlace 'file' --replace ', test) {' ', DISABLED_test) {'";
    assert disableOneTest "file with spaces"  "test"
      == "substituteInPlace 'file with spaces' --replace ', test) {' ', DISABLED_test) {'";

    assert disableTestSuite "suite"
      == "substituteInPlace CMakeLists.txt --replace 'TEST suite' 'TEST suite BROKEN'";

    assert disableTests {} == "";
    assert disableTests { "file" = []; } == "";
    assert disableTests { "file" = [ "test" ]; }
      == disableOneTest "file" "test";
    assert disableTests { "file" = [ "testA" "testB" ]; }
      == "${disableOneTest "file" "testA"}\n${disableOneTest "file" "testB"}";
    assert disableTests { "fileA" = [ "testA" ]; "fileB" = [ "testB" ]; }
      == "${disableOneTest "fileA" "testA"}\n${disableOneTest "fileB" "testB"}";
    assert disableTests { "mysuite" = true; } == disableTestSuite "mysuite";
    assert disableTests { "mysuite" = false; } == "";
    x;

  assertMsg = lib.assertMsg;
  escapeShellArg = lib.escapeShellArg;

in checkDisableTests disableTests
