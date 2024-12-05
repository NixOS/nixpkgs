{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  azure-common,
  azure-mgmt-core,
  isodate,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-netapp";
  version = "13.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "azure_mgmt_netapp";
    inherit version;
    hash = "sha256-N0Fnnigw6sk5M2Cx9T2CtMAe0S64WN73shukkWMkiEk=";
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
