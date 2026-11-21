{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-common,
  azure-mgmt-core,
  isodate,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-mgmt-netapp";
  version = "19.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_netapp";
    inherit (finalAttrs) version;
    hash = "sha256-XAeavKwh/MZ7CBeJUovu+O3Y34ZlgtB7CR8Xs8k4Moc=";
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

  meta = {
    description = "Microsoft Azure NetApp Files Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-netapp_${finalAttrs.version}/sdk/netapp/azure-mgmt-netapp/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
