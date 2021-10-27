{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, azure-mgmt-common
, azure-mgmt-core
, msrest
, msrestazure
, isPy3k
}:

buildPythonPackage rec {
  version = "19.2.0";
  pname = "azure-mgmt-network";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "c8da1cf9523b89d4b268546ea087153372633962e31a4e6befae20d0ae308bac";
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
