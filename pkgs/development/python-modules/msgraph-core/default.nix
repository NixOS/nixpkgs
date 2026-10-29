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
  version = "1.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoftgraph";
    repo = "msgraph-sdk-python-core";
    tag = "v${version}";
    hash = "sha256-0aTdmRAddiJy6z0+guG9e36qJ3cBdt5tD4B20oOhASE=";
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
