{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  msrest,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-hdinsight";
  version = "9.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QevcacDR+B0l3TBDjBT/9DMfZmOfVYBbkYuWSer/54o=";
    extension = "zip";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    msrest
  ];

  # no tests included
  doCheck = false;

  pythonNamespaces = [ "azure.mgmt" ];

  pythonImportsCheck = [
    "azure.mgmt.hdinsight"
  ];

  meta = {
    description = "Microsoft Azure HDInsight Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/hdinsight/azure-mgmt-hdinsight";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-hdinsight_${version}/sdk/hdinsight/azure-mgmt-hdinsight/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
