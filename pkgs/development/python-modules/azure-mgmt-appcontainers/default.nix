{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  azure-common,
  azure-mgmt-core,
  isodate,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-appcontainers";
  version = "3.2.0";
  format = "setuptools";
  pyroject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "azure_mgmt_appcontainers";
    inherit version;
    hash = "sha256-bp7WPCwssPZD+tZ52BMIxKomFWztQfwDPl9MBJghjz4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    isodate
  ] ++ lib.optionals (pythonOlder "3.8") [ typing-extensions ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.appcontainers" ];

  meta = with lib; {
    description = "Microsoft Azure Appcontainers Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/appcontainers/azure-mgmt-appcontainers";
    license = licenses.mit;
    maintainers = with maintainers; [ jfroche ];
  };
}
