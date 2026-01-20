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
  version = "1.7.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Pr5B6b4/SubKYeXbxCxLfMAHoBBUqFBlAaJt/Bmf0+w=";
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
