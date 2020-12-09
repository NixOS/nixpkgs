{ lib, buildPythonPackage, fetchPypi, pythonOlder
, azure-common
, msrest
, msrestazure
}:

buildPythonPackage rec {
  pname = "azure-mgmt-synapse";
  version = "0.5.0";
  disabled = pythonOlder "3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4eb76230c38525b71eb1addefebd265bc3d9b68ba7ff60ce5356d39f68ed2837";
    extension = "zip";
  };

  propagatedBuildInputs = [
    azure-common
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
