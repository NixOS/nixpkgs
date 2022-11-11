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
  version = "0.2.2";

  disabled = pythonOlder "3.5";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "microsoftgraph";
    repo = "msgraph-sdk-python-core";
    rev = "v${version}";
    hash = "sha256-eRRlG3GJX3WeKTNJVWgNTTHY56qiUGOlxtvEZ2xObLA=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    requests
  ];

  checkInputs = [
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
