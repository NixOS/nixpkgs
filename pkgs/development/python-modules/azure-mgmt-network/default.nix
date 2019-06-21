{ lib, buildAzureMgmtPythonPackage, fetchPypi, python, isPy3k
, azure-common
, azure-mgmt-nspkg
, msrest
, msrestazure
}:

buildAzureMgmtPythonPackage rec {
  version = "3.0.0";
  pname = "azure-mgmt-network";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "05p59dpzy7akxwgqj11c15fmfqv6m86k4qqycfz37nk7qdclfzvv";
  };

  propagatedBuildInputs = [
    azure-common
    msrest
    msrestazure
  ] ++ lib.optional (!isPy3k) azure-mgmt-nspkg;

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/master/sdk/network/azure-mgmt-network";
    license = licenses.mit;
    maintainers = with maintainers; [ olcai mwilsoninsight jonringer ];
  };
}
