{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  pythonOlder,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-monitor";
  version = "7.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-t19TZEHUMPaf+HOhZG5fXbyzCAoQdopZ0K3AFUFiOBY=";
  };

  propagatedBuildInputs = [
    isodate
    azure-common
    azure-mgmt-core
  ]
  ++ lib.optionals (pythonOlder "3.8") [ typing-extensions ];

  pythonNamespaces = [ "azure.mgmt" ];

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Monitor Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
