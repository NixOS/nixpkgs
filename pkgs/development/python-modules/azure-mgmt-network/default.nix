{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, azure-mgmt-core
, msrest
, msrestazure
, isPy3k
}:

buildPythonPackage rec {
  version = "19.3.0";
  pname = "azure-mgmt-network";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0b6a1ccdffd76e057ab16a6c319740a0ca68d59fedf7e9c02f2437396e72aa11";
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    msrest
    msrestazure
  ];

  # has no tests
  doCheck = false;

  pythonNamespaces = [ "azure.mgmt" ];

  pythonImportsCheck = [ "azure.mgmt.network" ];

  meta = with lib; {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ olcai maxwilson jonringer ];
  };
}
