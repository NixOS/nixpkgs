{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-dashboard";
  version = "1.1.0";
  format = "wheel";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "azure_mgmt_dashboard";
    inherit version;
    format = "wheel";
    python = "py3";
    dist = "py3";
    hash = "sha256-WoZW5p30f0mrmMyhD68nxqlGrTtUU93V167B8wZitdA=";
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    isodate
    typing-extensions
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.dashboard" ];

  meta = with lib; {
    description = "Microsoft Azure Dashboard Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/main/sdk/dashboard/azure-mgmt-dashboard/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ techknowlogick ];
  };
}
