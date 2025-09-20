{
  lib,
  azure-mgmt-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-compute";
  version = "36.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "azure_mgmt_compute";
    inherit version;
    hash = "sha256-7jQ9qj9bNJTsqgenCsXEM30j6gBlkGMpGasoNcMuZ6E=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-mgmt-common
    azure-mgmt-core
    isodate
  ];

  pythonNamespaces = [ "azure.mgmt" ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.compute" ];

  meta = with lib; {
    description = "This is the Microsoft Azure Compute Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/compute/azure-mgmt-compute";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-compute_${version}/sdk/compute/azure-mgmt-compute/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      olcai
      maxwilson
    ];
  };
}
