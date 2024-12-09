{
  lib,
  aiohttp,
  azure-kusto-data,
  azure-storage-blob,
  azure-storage-queue,
  buildPythonPackage,
  fetchFromGitHub,
  pandas,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  responses,
  setuptools,
  tenacity,
}:

buildPythonPackage rec {
  pname = "azure-kusto-ingest";
  version = "4.6.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-kusto-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-rm8G3/WAUlK1/80uk3uiTqDA5hUIr+VVZEmPe0mYBjI=";
  };

  sourceRoot = "${src.name}/${pname}";

  build-system = [ setuptools ];

  dependencies = [
    azure-kusto-data
    azure-storage-blob
    azure-storage-queue
    tenacity
  ];

  optional-dependencies = {
    pandas = [ pandas ];
  };

  nativeCheckInputs = [
    aiohttp
    pytest-asyncio
    pytestCheckHook
    responses
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "azure.kusto.ingest" ];

  disabledTestPaths = [
    # Tests require network access
    "tests/test_e2e_ingest.py"
  ];

  meta = {
    description = "Module for Kusto Ingest";
    homepage = "https://github.com/Azure/azure-kusto-python/tree/master/azure-kusto-ingest";
    changelog = "https://github.com/Azure/azure-kusto-python/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
