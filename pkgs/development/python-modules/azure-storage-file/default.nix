{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, azure-storage-common
, isPy3k
, futures
}:

buildPythonPackage rec {
  pname = "azure-storage-file";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5217b0441b671246a8d5f506a459fa3af084eeb9297c5be3bbe95d75d23bac2f";
  };

  propagatedBuildInputs = [
    azure-common
    azure-storage-common
  ] ++ lib.optional (!isPy3k) futures;

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "Client library for Microsoft Azure Storage services containing the file service APIs";
    homepage = https://github.com/Azure/azure-storage-python/tree/master/azure-storage-file;
    license = licenses.mit;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
