{ lib, buildPythonPackage, fetchPypi, pythonOlder
, azure-common
, msrest
, msrestazure
}:

buildPythonPackage rec {
  pname = "azure-mgmt-synapse";
  version = "0.6.0";
  disabled = pythonOlder "3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f81cb52b220774aab93ffcf25bdc17e03fd84b6916836640789f86fbf636b984";
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
