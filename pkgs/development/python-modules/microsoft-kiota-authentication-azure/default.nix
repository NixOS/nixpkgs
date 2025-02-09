{
  lib,
  aiohttp,
  azure-core,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  microsoft-kiota-abstractions,
  opentelemetry-api,
  opentelemetry-sdk,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "microsoft-kiota-authentication-azure";
  version = "1.9.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "kiota-python";
    tag = "microsoft-kiota-authentication-azure-v${version}";
    hash = "sha256-ESRnI8prXG1h5H5RVD4eOQ1sQYSEMMLVHSk8yhzFGVw=";
  };

  sourceRoot = "source/packages/authentication/azure/";

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    azure-core
    microsoft-kiota-abstractions
    opentelemetry-api
    opentelemetry-sdk
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "kiota_authentication_azure" ];

  meta = with lib; {
    description = "Kiota Azure authentication provider";
    homepage = "https://github.com/microsoft/kiota-python/tree/main/packages/authentication/azure";
    changelog = "https://github.com/microsoft/kiota-python/releases/tag/microsoft-kiota-authentication-azure-v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
