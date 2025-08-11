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
  version = "2.0.0";

  pyproject = true;

  src = fetchPypi {
    pname = "azure_monitor_query";
    inherit version;
    hash = "sha256-ewXy/KxPtn/J93p9TF2YoPMJn7c7V8aewbCAdzmUZxs=";
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
