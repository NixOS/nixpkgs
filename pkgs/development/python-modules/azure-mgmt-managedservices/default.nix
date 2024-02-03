{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, azure-mgmt-core
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "6.0.0";
  format = "setuptools";
  pname = "azure-mgmt-managedservices";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ec0cb3858bcf8edf5eee0eddee81560424eb84352e0df082ddc94eb99badfd5e";
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

  pythonImportsCheck = [ "azure.common" "azure.mgmt.managedservices" ];

  meta = with lib; {
    description = "Microsoft Azure Managed Services Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
