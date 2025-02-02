{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  azure-common,
  azure-mgmt-core,
  isodate,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-containerregistry";
  version = "10.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-riFlGFXfsZxC2R1rOpZcbGEeI/i8S/cTiDXmUtL5GOM=";
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    isodate
  ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [
    "azure.common"
    "azure.mgmt.containerregistry"
  ];

  meta = with lib; {
    description = "Microsoft Azure Container Registry Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-containerregistry_${version}/sdk/containerregistry/azure-mgmt-containerregistry/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
