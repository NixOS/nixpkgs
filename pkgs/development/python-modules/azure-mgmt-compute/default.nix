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
  version = "31.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WlscT8GhnssCKhLe0b6LGxVfaXnQP7nvwEZC9gZkS78=";
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
