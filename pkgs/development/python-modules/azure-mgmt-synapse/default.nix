{ lib, buildPythonPackage, fetchPypi, pythonOlder
, azure-common
, msrest
, msrestazure
}:

buildPythonPackage rec {
  pname = "azure-mgmt-synapse";
  version = "0.4.0";
  disabled = pythonOlder "3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ebd4dcb980a6425f4db7dd94225332b6bd74e1089b0c6e57af868d96ceab1d3c";
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
