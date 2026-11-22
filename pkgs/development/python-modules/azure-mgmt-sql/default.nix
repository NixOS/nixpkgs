{
  lib,
  buildPythonPackage,
  fetchPypi,
  typing-extensions,
  isodate,
  azure-common,
  azure-mgmt-core,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-mgmt-sql";
  version = "4.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_sql";
    inherit (finalAttrs) version;
    hash = "sha256-s5dW+c+KzucnZPHHRSEcbGNfpfa/wnF03ipYaQkXJis=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    isodate
    typing-extensions
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.sql" ];

  meta = {
    description = "This is the Microsoft Azure SQL Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
})
