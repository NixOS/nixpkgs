{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  setuptools,
  azure-core,
  isodate,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-monitor-ingestion";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "azure_monitor_ingestion";
    inherit version;
    hash = "sha256-l6/ueA2a4waRKM3ncCfUzGL6gk/mTVusiArEpksKDE4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-core
    isodate
    typing-extensions
  ];

  pythonImportsCheck = [
    "azure.monitor.ingestion"
    "azure.monitor.ingestion.aio"
  ];

  # requires checkout from mono-repo and a mock account
  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-monitor-ingestion_${version}/sdk/monitor/azure-monitor-ingestion/CHANGELOG.md";
    description = "Send custom logs to Azure Monitor using the Logs Ingestion API";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/monitor/azure-monitor-ingestion";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
