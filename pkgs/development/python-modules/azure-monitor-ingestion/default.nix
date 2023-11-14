{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools
, azure-core
, isodate
, typing-extensions
}:

buildPythonPackage rec {
  pname = "azure-monitor-ingestion";
  version = "1.0.2";

  disabled = pythonOlder "3.7";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-xNpYsD1bMIM0Bxy8KtR4rYy4tzfddtoPnEzHfO44At8=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
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

  meta = {
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-monitor-ingestion_${version}/sdk/monitor/azure-monitor-ingestion/CHANGELOG.md";
    description = "Send custom logs to Azure Monitor using the Logs Ingestion API";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/monitor/azure-monitor-ingestion";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
