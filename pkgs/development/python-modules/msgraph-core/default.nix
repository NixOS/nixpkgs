{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, httpx
, microsoft-kiota-abstractions
, microsoft-kiota-authentication-azure
 ,microsoft-kiota-http
, requests
, azure-identity
, pytestCheckHook
, responses
}:

buildPythonPackage rec {
  pname = "msgraph-core";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.5";


  src = fetchFromGitHub {
    owner = "microsoftgraph";
    repo = "msgraph-sdk-python-core";
    rev = "refs/tags/v${version}";
    hash = "sha256-VizjN7sXqPvo9VOSaaUnogTlUDJ1OA2COYNTcVRqhJA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    httpx
    microsoft-kiota-abstractions
    microsoft-kiota-authentication-azure
    microsoft-kiota-http
    requests

  ];

  nativeCheckInputs = [
    azure-identity
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [
    "msgraph_core"
  ];

  meta = {
    description = "Core component of the Microsoft Graph Python SDK";
    homepage = "https://github.com/microsoftgraph/msgraph-sdk-python-core";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
