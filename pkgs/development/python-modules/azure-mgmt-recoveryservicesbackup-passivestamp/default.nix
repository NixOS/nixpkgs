{
  lib,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  msrest,
  setuptools,
  typing-extensions,
  azure-cli,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-mgmt-recoveryservicesbackup-passivestamp";
  version = "1.0.0b1";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_recoveryservicesbackup_passivestamp";
    inherit (finalAttrs) version;
    hash = "sha256-ri2UBG9Z3PdDxxaIRlxf4rvNGpaDoKHWhLVJ/lbBh9U=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-mgmt-core
    msrest
    typing-extensions
  ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.recoveryservicesbackup.passivestamp" ];

  meta = {
    description = "Microsoft Azure Passivestamp Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-recoveryservicesbackup-passivestamp_${finalAttrs.version}/sdk/recoveryservices/azure-mgmt-recoveryservicesbackup-passivestamp/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = azure-cli.meta.maintainers;
  };
})
