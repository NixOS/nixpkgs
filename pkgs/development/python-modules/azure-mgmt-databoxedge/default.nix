{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  msrest,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-databoxedge";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-BAkAYrwejwDC9FMVo7zrD7OzR57BR01xuINC4TSZsIc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    msrest
  ];

  # no tests in pypi tarball
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.databoxedge" ];

  meta = with lib; {
    description = "Microsoft Azure Databoxedge Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/databox/azure-mgmt-databox";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-databoxedge_${version}/sdk/databox/azure-mgmt-databox/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
