{
  lib,
  aiohttp,
  azure-core,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
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
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "kiota-authentication-azure-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-RA0BbIwDs3cXiH4tQsvCGUO1OAg+DWjEeWd7MEVIC8E=";
  };

  build-system = [ flit-core ];

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
    homepage = "https://github.com/microsoft/kiota-authentication-azure-python";
    changelog = "https://github.com/microsoft/kiota-authentication-azure-python/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
