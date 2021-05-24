{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, azure-mgmt-core
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "2.0.0";
  pname = "azure-mgmt-apimanagement";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "54fade87af54904c8ac9785efccebc537c58a3c1f8726e929e473698f06ebbfc";
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
