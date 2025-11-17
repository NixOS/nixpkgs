{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-common,
  azure-mgmt-core,
  isodate,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-netapp";
  version = "14.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_netapp";
    inherit version;
    hash = "sha256-ykYLisZMhwPUnos5pJzgbxZsqF6R6IcQRAyMSF+96G4=";
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
    "azure.mgmt.netapp"
  ];

  meta = with lib; {
    description = "Microsoft Azure NetApp Files Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-netapp_${version}/sdk/netapp/azure-mgmt-netapp/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
