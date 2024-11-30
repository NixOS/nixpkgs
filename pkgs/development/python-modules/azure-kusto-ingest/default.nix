{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  azure-kusto-data,
  azure-storage-blob,
  azure-storage-queue,
  tenacity,
  pandas,
}:

buildPythonPackage rec {
  pname = "azure-kusto-ingest";
  version = "4.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-kusto-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-rm8G3/WAUlK1/80uk3uiTqDA5hUIr+VVZEmPe0mYBjI=";
  };

  sourceRoot = "${src.name}/azure-kusto-ingest";

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

  # Tests require secret connection strings
  # and a network connection.
  doCheck = false;

  pythonImportsCheck = [ "azure.kusto.ingest" ];

  meta = {
    changelog = "https://github.com/Azure/azure-kusto-python/releases/tag/v${version}";
    description = "Kusto Ingest Client";
    homepage = "https://github.com/Azure/azure-kusto-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
