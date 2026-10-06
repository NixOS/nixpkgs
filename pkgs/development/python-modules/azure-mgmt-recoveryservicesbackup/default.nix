{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-mgmt-recoveryservicesbackup";
  version = "11.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_recoveryservicesbackup";
    inherit (finalAttrs) version;
    hash = "sha256-t7SrF0boqSC4DB8Sp+gG3BPwulz341fHtFfFYm/ibeQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    isodate
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.recoveryservicesbackup" ];

  meta = {
    description = "This is the Microsoft Azure Recovery Services Backup Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-recoveryservicesbackup_${finalAttrs.version}/sdk/recoveryservices/azure-mgmt-recoveryservicesbackup/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
})
