{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  msrest,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-scheduler";
  version = "7.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "azure_mgmt_scheduler";
    inherit version;
    hash = "sha256-hzabrRKnOzxk2e0/HlJvS7QvWnibgLfqn8EW+vsFH6U=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    msrest
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.scheduler" ];

  meta = with lib; {
    description = "This is the Microsoft Azure Scheduler Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-scheduler_7.0.0/sdk/scheduler/azure-mgmt-scheduler/CHANGELOG.md";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-scheduler_${version}/sdk/scheduler/azure-mgmt-scheduler/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
