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
  pname = "azure-mgmt-extendedlocation";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_extendedlocation";
    inherit version;
    hash = "sha256-O1wdLwoh8V6bF29EAgbHAqH3f6S5ffHKQAH5kavPfNE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    isodate
    typing-extensions
  ];

  # Tests are only available in mono repo
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.extendedlocation" ];

  meta = {
    description = "Microsoft Azure Extendedlocation Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/extendedlocation/azure-mgmt-extendedlocation";
    changelog = "https://github.com/Azure/azure-sdk-for-python/tree/azure-mgmt-extendedlocation_${version}/sdk/extendedlocation/azure-mgmt-extendedlocation";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
