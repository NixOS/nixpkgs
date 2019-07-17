{ lib, buildAzureMgmtPythonPackage, fetchPypi, isPy3k, python
, azure-common
, azure-mgmt-nspkg
, msrest
, msrestazure
}:

buildAzureMgmtPythonPackage rec {
  version = "6.0.0";
  pname = "azure-mgmt-compute";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1j9zxvpi33y40cq1hlhkc89qwsvbjh9307w903rbdmi2nxr92gk0";
  };

  propagatedBuildInputs = [
    azure-common
    msrest
    msrestazure
  ] ++ lib.optional (!isPy3k) azure-mgmt-nspkg;

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Compute Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/master/sdk/compute/azure-mgmt-compute";
    license = licenses.mit;
    maintainers = with maintainers; [ olcai mwilsoninsight jonringer ];
  };
}
