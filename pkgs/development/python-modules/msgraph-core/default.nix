{
  lib,
  buildPythonPackage,
  python-dotenv,
  fetchFromGitHub,
  setuptools,
  httpx,
  microsoft-kiota-abstractions,
  microsoft-kiota-authentication-azure,
  microsoft-kiota-http,
  microsoft-kiota-serialization-json,
  azure-identity,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "msgraph-core";
  version = "1.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoftgraph";
    repo = "msgraph-sdk-python-core";
    tag = "v${version}";
    hash = "sha256-oF9ipN8jEMFeC4b0jGlNPQWsk8/dTAmLzS4R/xfXZfk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    httpx
    microsoft-kiota-abstractions
    microsoft-kiota-authentication-azure
    microsoft-kiota-http
  ]
  ++ httpx.optional-dependencies.http2;

  nativeCheckInputs = [
    azure-identity
    microsoft-kiota-serialization-json
    pytest-asyncio
    pytestCheckHook
    python-dotenv
  ];

  pythonImportsCheck = [ "msgraph_core" ];

  meta = {
    description = "Core component of the Microsoft Graph Python SDK";
    homepage = "https://github.com/microsoftgraph/msgraph-sdk-python-core";
    changelog = "https://github.com/microsoftgraph/msgraph-sdk-python-core/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
