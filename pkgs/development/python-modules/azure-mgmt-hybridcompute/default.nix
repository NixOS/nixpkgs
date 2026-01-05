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
  pname = "azure-mgmt-hybridcompute";
  version = "9.1.0b2";
  format = "wheel";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "azure_mgmt_hybridcompute";
    inherit version;
    format = "wheel";
    python = "py3";
    dist = "py3";
    hash = "sha256-bKv4A6PjN6fMpyso0JqewADcKGOK1wXlULtkZpzrilY=";
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    isodate
    typing-extensions
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.hybridcompute" ];

  meta = with lib; {
    description = "Microsoft Azure Hybrid Compute Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/main/sdk/hybridcompute/azure-mgmt-hybridcompute/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ techknowlogick ];
  };
}
