{
  lib,
  azure-cli,
  azure-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-monitor-query";
  version = "1.4.1";

  pyproject = true;

  src = fetchPypi {
    pname = "azure_monitor_query";
    inherit version;
    hash = "sha256-cYJOK1d9Jd8NO+u7sFTAahrj68uRgxqbrAuzRNCt32g=";
  };

  nativeBuildInputs = [ setuptools ];

  dependencies = [
    azure-core
    isodate
    typing-extensions
  ];

  pythonImportsCheck = [
    "azure"
    "azure.monitor.query"
  ];

  meta = {
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-monitor-query_${version}/sdk/monitor/azure-monitor-query/CHANGELOG.md";
    description = "Microsoft Azure Monitor Query Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/monitor/azure-monitor-query";
    license = lib.licenses.mit;
    maintainers = azure-cli.meta.maintainers;
  };
}
