{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  opentelemetry-api,
  opentelemetry-sdk,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  std-uritemplate,
}:

buildPythonPackage rec {
  pname = "microsoft-kiota-abstractions";
  version = "1.6.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "kiota-python";
    rev = "refs/tags/${pname}-v${version}";
    hash = "sha256-OlQ4Goz/cVAshBv0KUVBnBLMvSk982QFIgh25SJCSwM=";
  };

  sourceRoot = "source/packages/abstractions/";

  build-system = [ poetry-core ];

  dependencies = [
    opentelemetry-api
    opentelemetry-sdk
    std-uritemplate
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "kiota_abstractions" ];

  meta = with lib; {
    description = "Abstractions library for Kiota generated Python clients";
    homepage = "https://github.com/microsoft/kiota-abstractions-python";
    changelog = "https://github.com/microsoft/kiota-abstractions-python/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
