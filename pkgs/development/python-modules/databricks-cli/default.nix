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
  version = "0.17.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "databricks";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-Eg6qpoEvWlbOJbMIkbJiHfHVrglVfVNq/TCOhQxukl0=";
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
