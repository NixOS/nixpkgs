{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, httpx
, microsoft-kiota-abstractions
, microsoft-kiota-authentication-azure
, microsoft-kiota-http
, azure-identity
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "msgraph-core";
  version = "1.0.0";

  disabled = pythonOlder "3.8";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoftgraph";
    repo = "msgraph-sdk-python-core";
    rev = "v${version}";
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
  ] ++ httpx.optional-dependencies.http2;

  nativeCheckInputs = [
    azure-identity
    pytestCheckHook
  ];

  pythonImportsCheck = [ "msgraph_core" ];

  meta = {
    changelog = "https://github.com/microsoftgraph/msgraph-sdk-python-core/blob/${src.rev}/CHANGELOG.md";
    description = "Core component of the Microsoft Graph Python SDK";
    homepage = "https://github.com/microsoftgraph/msgraph-sdk-python-core";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
