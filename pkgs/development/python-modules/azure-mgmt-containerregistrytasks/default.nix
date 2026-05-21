{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-common,
  azure-mgmt-core,
  isodate,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-containerregistrytasks";
  version = "1.0.0b1";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_containerregistrytasks";
    inherit version;
    hash = "sha256-1nMN1cm/yp/fD+D5M3BtPH+4VcoQxWhQZQsHDpxsr1E=";
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
    "azure.mgmt.containerregistrytasks"
  ];

  meta = {
    description = "Microsoft Azure Container Registry Tasks Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/containerregistry/azure-mgmt-containerregistrytasks";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
