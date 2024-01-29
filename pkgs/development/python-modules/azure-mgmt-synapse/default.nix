{ lib, buildPythonPackage, fetchPypi, pythonOlder
, azure-common
, azure-mgmt-core
, msrest
, msrestazure
}:

buildPythonPackage rec {
  pname = "azure-mgmt-synapse";
  version = "2.0.0";
  format = "setuptools";
  disabled = pythonOlder "3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bec6bdfaeb55b4fdd159f2055e8875bf50a720bb0fce80a816e92a2359b898c8";
    extension = "zip";
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    msrest
    msrestazure
  ];

  pythonImportsCheck = [ "azure.mgmt.synapse" ];

  meta = with lib; {
    description = "Azure python SDK";
    homepage = "https://github.com/Azure/azure-sdk-for-python/";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
