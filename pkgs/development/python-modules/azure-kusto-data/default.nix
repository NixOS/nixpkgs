{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  python-dateutil,
  requests,
  azure-identity,
  msal,
  ijson,
  azure-core,
  asgiref,
  aiohttp,
  pandas,
}:

buildPythonPackage rec {
  pname = "azure-kusto-data";
  version = "4.6.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tfOnb6rFjTzg4af26gK5gk1185mejAiaDvetE/r4L0Q=";
  };

  build-system = [ setuptools ];

  dependencies = [
    python-dateutil
    requests
    azure-identity
    msal
    ijson
    azure-core
  ];

  optional-dependencies = {
    pandas = [ pandas ];
    aio = [
      aiohttp
      asgiref
    ];
  };

  # Tests require secret connection strings
  # and a network connection.
  doCheck = false;

  pythonImportsCheck = [ "azure.kusto.data" ];

  meta = {
    changelog = "https://github.com/Azure/azure-kusto-python/releases/tag/v${version}";
    description = "Kusto Data Client";
    homepage = "https://github.com/Azure/azure-kusto-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
