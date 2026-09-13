{
  lib,
  azure-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-appconfiguration";
  version = "1.9.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_appconfiguration";
    inherit version;
    hash = "sha256-OZZ39WNI6RB9epen5H22cjx9LGF/7b6miB7ae47tmVs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-core
    isodate
  ];

  # Tests are not shipped
  doCheck = false;

  pythonImportsCheck = [ "azure.appconfiguration" ];

  meta = {
    description = "Microsoft App Configuration Data Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/master/sdk/appconfiguration/azure-appconfiguration";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-appconfiguration_${version}/sdk/appconfiguration/azure-appconfiguration/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
