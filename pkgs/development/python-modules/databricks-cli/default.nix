{ lib
, buildPythonPackage
, click
, configparser
, decorator
, fetchFromGitHub
, mock
, oauthlib
, pyjwt
, pytestCheckHook
, pythonOlder
, requests
, requests-mock
, six
, tabulate
}:

buildPythonPackage rec {
  pname = "databricks-cli";
<<<<<<< HEAD
  version = "0.17.7";
=======
  version = "0.17.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "databricks";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-Eg6qpoEvWlbOJbMIkbJiHfHVrglVfVNq/TCOhQxukl0=";
=======
    hash = "sha256-K20fhfdJuABqpbm8O8PSA9pIW8Uu1MdlP3r5E49pt6Q=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    click
    configparser
    oauthlib
    pyjwt
    requests
    requests-mock
    six
    tabulate
  ];

  nativeCheckInputs = [
    decorator
    mock
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Disabled due to option parsing which we don't have
    "integration/dbfs/test_integration.py"
    "integration/workspace/test_integration.py"
  ];

  pythonImportsCheck = [
    "databricks_cli"
  ];

  meta = with lib; {
    description = "Command line interface for Databricks";
    homepage = "https://github.com/databricks/databricks-cli";
    changelog = "https://github.com/databricks/databricks-cli/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ tbenst ];
  };
}
