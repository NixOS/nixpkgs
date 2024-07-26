{
  azure-cli,
  azure-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  lib,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-monitor-query";
  version = "1.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-629Un2FJr0SExRq/m7tmEjn1eBRfi+9lSFWXbu9CL+Y=";
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
