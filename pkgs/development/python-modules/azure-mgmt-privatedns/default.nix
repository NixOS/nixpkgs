{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-privatedns";
  version = "1.2.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_privatedns";
    inherit version;
    hash = "sha256-NCMYcvAblPYZXY7lQo4XRpJS7QTqCCjVIyXr578KEgs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    isodate
    typing-extensions
  ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [
    "azure.common"
    "azure.mgmt.privatedns"
  ];

  meta = {
    description = "Microsoft Azure DNS Private Zones Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/network/azure-mgmt-privatedns";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-privatedns_${version}/sdk/network/azure-mgmt-privatedns/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
