{ lib, buildAzureMgmtPythonPackage, fetchPypi, isPy3k, python
, azure-common
, azure-mgmt-common
, azure-mgmt-nspkg
, msrest
, msrestazure
}:

buildAzureMgmtPythonPackage rec {
  version = "4.0.0";
  pname = "azure-mgmt-storage";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1kxd30s2axn3g4qx3v7q3d5l744a29xlfk3q06ra0rqm1p6prvgv";
  };

  propagatedBuildInputs = [
    azure-common
    msrest
    msrestazure
  ] ++ lib.optional (!isPy3k) azure-mgmt-nspkg;

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Storage Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/master/sdk/storage/azure-mgmt-storage";
    license = licenses.mit;
    maintainers = with maintainers; [ olcai mwilsoninsight jonringer ];
  };
}
