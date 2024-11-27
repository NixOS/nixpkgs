{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-network";
  version = "28.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "azure_mgmt_network";
    inherit version;
    hash = "sha256-QDVtNI70g4Mk8ZpBzYA0C0+N1KwvChiky9XMle8pdPM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    isodate
  ];

  # Module has no tests
  doCheck = false;

  pythonNamespaces = [ "azure.mgmt" ];

  pythonImportsCheck = [ "azure.mgmt.network" ];

  meta = with lib; {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/network/azure-mgmt-network";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-network_${version}/sdk/network/azure-mgmt-network/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      olcai
      maxwilson
    ];
  };
}
