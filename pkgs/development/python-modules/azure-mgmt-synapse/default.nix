{ lib, buildPythonPackage, fetchPypi, pythonOlder
, azure-common
, msrest
, msrestazure
}:

buildPythonPackage rec {
  pname = "azure-mgmt-synapse";
  version = "0.3.0";
  disabled = pythonOlder "3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0sa12s5af9xl1wnblilswxc6ydr2anm9an000iz3ks54pydby2vy";
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
