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

buildPythonPackage (finalAttrs: {
  pname = "azure-mgmt-managementgroups";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_managementgroups";
    inherit (finalAttrs) version;
    hash = "sha256-AtAI+t/XYQsccFnjw6ijPe2u9LZUdJuBl4tDe68mTx0=";
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

  meta = {
    description = "This is the Microsoft Azure Management Groups Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/managementgroups/azure-mgmt-managementgroups";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
})
