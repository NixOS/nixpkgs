{
  lib,
  buildPythonPackage,
  python-dotenv,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  httpx,
  microsoft-kiota-abstractions,
  microsoft-kiota-authentication-azure,
  microsoft-kiota-http,
  requests,
  azure-identity,
  pytestCheckHook,
  responses,
}:

buildPythonPackage rec {
  pname = "msgraph-core";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "microsoftgraph";
    repo = "msgraph-sdk-python-core";
    tag = "v${version}";
    hash = "sha256-B0dff5ynokI49P0irgPOWvqwHKt4mKv3/+XwfbgwMF8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    httpx
    microsoft-kiota-abstractions
    microsoft-kiota-authentication-azure
    microsoft-kiota-http
    requests
  ];

  nativeCheckInputs = [
    azure-identity
    pytestCheckHook
    python-dotenv
    responses
  ];

  pythonImportsCheck = [ "msgraph_core" ];

  disabledTestPaths = [
    # client_id should be the id of a Microsoft Entra application
    "tests/tasks/test_page_iterator.py"
  ];

  meta = {
    description = "Core component of the Microsoft Graph Python SDK";
    homepage = "https://github.com/microsoftgraph/msgraph-sdk-python-core";
    changelog = "https://github.com/microsoftgraph/msgraph-sdk-python-core/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
