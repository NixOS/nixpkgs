{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-servicefabric";
  version = "2.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oIQzBJVUQ2yQhEvIqWgg6INplITm/8mQMv0lcfjF99Y=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    isodate
    azure-common
    azure-mgmt-core
  ];

  pythonNamespaces = [ "azure.mgmt" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "This is the Microsoft Azure Service Fabric Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/servicefabric/azure-mgmt-servicefabric";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-servicefabric_${version}/sdk/servicefabric/azure-mgmt-servicefabric/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
}
