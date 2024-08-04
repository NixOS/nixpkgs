{
  lib,
  azure-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-appconfiguration";
  version = "1.6.0";
  pyporject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-z2KKPh6mZDR5ZDzSRt2kZO3Eq3hXQzOaao/oCbwTf+w=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-core
    isodate
  ];

  # Tests are not shipped
  doCheck = false;

  pythonImportsCheck = [ "azure.appconfiguration" ];

  meta = with lib; {
    description = "Microsoft App Configuration Data Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/master/sdk/appconfiguration/azure-appconfiguration";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-appconfiguration_${version}/sdk/appconfiguration/azure-appconfiguration/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
