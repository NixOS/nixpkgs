{
  lib,
  buildPythonPackage,
  fetchPypi,
  msrest,
  msrestazure,
  azure-common,
  azure-mgmt-core,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-containerinstance";
  version = "10.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-eNQ3rbKFdPRIyDjtXwH5ztN4GWCYBh3rWdn3AxcEwX4=";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
    azure-mgmt-core
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.containerinstance" ];

  meta = {
    description = "This is the Microsoft Azure Container Instance Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
}
