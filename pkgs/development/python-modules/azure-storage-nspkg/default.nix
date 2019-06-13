{ lib
, buildPythonPackage
, fetchPypi
, azure-nspkg
}:

buildPythonPackage rec {
  pname = "azure-storage-nspkg";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6f3bbe8652d5f542767d8433e7f96b8df7f518774055ac7c92ed7ca85f653811";
  };

  propagatedBuildInputs = [
    azure-nspkg
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "Client library for Microsoft Azure Storage services owning the azure.storage namespace, user should not use this directly";
    homepage = https://github.com/Azure/azure-storage-python/tree/master/azure-storage-nspkg;
    license = licenses.mit;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
