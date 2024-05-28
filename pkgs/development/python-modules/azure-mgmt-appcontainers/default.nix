{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  azure-common,
  azure-mgmt-core,
  isodate,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-appcontainers";
  version = "3.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oqKPEOnZaIU7IMzDqT552IBJr9RtWt3vFO3SlG8igs0=";
  };

  propagatedBuildInputs = [
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
