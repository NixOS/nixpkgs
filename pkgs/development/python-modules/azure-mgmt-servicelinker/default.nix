{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, azure-mgmt-core
, msrest
}:

buildPythonPackage rec {
  pname = "azure-mgmt-servicelinker";
  version = "1.0.0b1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4f70d3bcd98ba539bfef870e3c497ebdc5efed3200c2627a61718baa9ab21a61";
    extension = "zip";
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    msrest
  ];

  pythonImportsCheck = [ "azure.mgmt.servicelinker" ];

  # no tests with sdist
  doCheck = false;

  meta = with lib; {
    description = "Microsoft Azure Servicelinker Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
