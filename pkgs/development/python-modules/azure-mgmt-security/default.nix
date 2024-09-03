{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-security";
  version = "7.0.0";
  fpyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WRLu1+nTdY/cqNJuHcJrQZQ9xHAyCKEYQmbiwlLhrWY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    isodate
  ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [
    "azure.common"
    "azure.mgmt.security"
  ];

  meta = with lib; {
    description = "Microsoft Azure Security Center Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/security/azure-mgmt-security";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-security_${version}/sdk/security/azure-mgmt-security/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
