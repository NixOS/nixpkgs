{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  msrest,
  azure-common,
  azure-mgmt-core,
  typing-extensions,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-reservations";
  version = "2.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-BHCFEFst5jfyIEo0hm86belpxW7EygZCBJ8PTqzqHKc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    msrest
    azure-common
    azure-mgmt-core
  ] ++ lib.optionals (pythonOlder "3.8") [ typing-extensions ];

  # has no tests
  doCheck = false;

  meta = {
    description = "This is the Microsoft Azure Reservations Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
}
