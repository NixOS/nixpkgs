{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, azure-mgmt-core
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "1.0.0";
  pname = "azure-mgmt-apimanagement";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "3ad7e2c3d20dd0141f9e2c0ae923121f7cbe7333bb314850e6f8b606636e3589";
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

  pythonImportsCheck = [ "azure.common" "azure.mgmt.apimanagement" ];

  meta = with lib; {
    description = "Microsoft Azure API Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
