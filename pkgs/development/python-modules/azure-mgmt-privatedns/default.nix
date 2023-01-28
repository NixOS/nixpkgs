{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, azure-mgmt-core
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "1.0.0";
  pname = "azure-mgmt-privatedns";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b60f16e43f7b291582c5f57bae1b083096d8303e9d9958e2c29227a55cc27c45";
    extension = "zip";
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    msrest
    msrestazure
  ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [ "azure.common" "azure.mgmt.privatedns" ];

  meta = with lib; {
    description = "Microsoft Azure DNS Private Zones Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
