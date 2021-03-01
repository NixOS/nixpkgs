{ lib, buildPythonPackage, fetchPypi, pythonOlder
, azure-common
, msrest
, msrestazure
}:

buildPythonPackage rec {
  pname = "azure-mgmt-synapse";
  version = "0.7.0";
  disabled = pythonOlder "3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3cf37df471f75441b0afe98a0f3a548434e9bc6a6426dca8c089950b5423f63f";
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
