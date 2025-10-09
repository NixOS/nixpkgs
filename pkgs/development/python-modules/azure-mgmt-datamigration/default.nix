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
  pname = "azure-mgmt-datamigration";
  version = "10.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_datamigration";
    inherit version;
    hash = "sha256-wo748WK5RaTLUAZASjA3QcJG8DMSSeYB0V6h/c6VxUo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    isodate
    typing-extensions
  ];

  pythonNamespaces = [ "azure.mgmt" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Data Migration Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/datamigration/azure-mgmt-datamigration";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
