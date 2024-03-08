{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, flit-core
, requests
, pytestCheckHook
, responses
}:

buildPythonPackage rec {
  pname = "msgraph-core";
  version = "1.0.0";

  disabled = pythonOlder "3.5";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "microsoftgraph";
    repo = "msgraph-sdk-python-core";
    rev = "refs/tags/v${version}";
    hash = "sha256-VizjN7sXqPvo9VOSaaUnogTlUDJ1OA2COYNTcVRqhJA=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  disabledTestPaths = [
    "tests/integration"
  ];

  pythonImportsCheck = [ "msgraph.core" ];

  meta = {
    description = "Core component of the Microsoft Graph Python SDK";
    homepage = "https://github.com/microsoftgraph/msgraph-sdk-python-core";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
