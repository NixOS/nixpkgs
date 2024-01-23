{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, aiohttp
, azure-core
, microsoft-kiota-abstractions
, opentelemetry-api
, opentelemetry-sdk
, pytest-asyncio
, pytest-mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "microsoft-kiota-authentication-azure";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "kiota-authentication-azure-python";
    rev = "v${version}";
    hash = "sha256-RA0BbIwDs3cXiH4tQsvCGUO1OAg+DWjEeWd7MEVIC8E=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    aiohttp
    azure-core
    microsoft-kiota-abstractions
    opentelemetry-api
    opentelemetry-sdk
  ];

  pythonImportsCheck = [ "kiota_authentication_azure" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/microsoft/kiota-authentication-azure-python/blob/${src.rev}/CHANGELOG.md";
    description = "Kiota Azure authentication provider for python clients";
    homepage = "https://github.com/microsoft/kiota-authentication-azure-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
