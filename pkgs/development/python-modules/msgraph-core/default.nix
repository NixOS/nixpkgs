{ lib
, azure-identity
, buildPythonPackage
, fetchFromGitHub
, flit-core
, httpx
, microsoft-kiota-abstractions
, microsoft-kiota-authentication-azure
, microsoft-kiota-http
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "msgraph-core";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

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
    httpx
    microsoft-kiota-abstractions
    microsoft-kiota-authentication-azure
    microsoft-kiota-http
  ] ++ httpx.optional-dependencies.http2;

  nativeCheckInputs = [
    azure-identity
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "msgraph_core"
  ];

  meta = {
    description = "Core component of the Microsoft Graph Python SDK";
    homepage = "https://github.com/microsoftgraph/msgraph-sdk-python-core";
    changelog = "https://github.com/microsoftgraph/msgraph-sdk-python-core/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
