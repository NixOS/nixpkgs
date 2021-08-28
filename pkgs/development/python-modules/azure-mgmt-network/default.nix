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
  version = "19.0.0";
  pname = "azure-mgmt-network";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "5e39a26ae81fa58c13c02029700f8c7b22c3fd832a294c543e3156a91b9459e8";
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
