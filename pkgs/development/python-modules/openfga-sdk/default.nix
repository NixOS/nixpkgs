{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
  pytestCheckHook,
  aiohttp,
  build,
  mock,
  opentelemetry-api,
  pytest-asyncio,
  pytest-cov-stub,
  python-dateutil,
  hatchling,
  urllib3,
}:

buildPythonPackage rec {
  pname = "openfga-sdk";
  version = "0.10.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openfga";
    repo = "python-sdk";
    tag = "v${version}";
    hash = "sha256-OKldYozT/rWa1uU8yXO9UyHaOGsVVCLr62lN9TESY0g=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    build
    opentelemetry-api
    python-dateutil
    urllib3
  ];

  pythonImportsCheck = [ "openfga_sdk" ];

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/openfga/python-sdk/blob/${src.tag}/CHANGELOG.md";
    description = "Fine-Grained Authorization solution for Python";
    homepage = "https://github.com/openfga/python-sdk";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nicklewis ];
  };
}
