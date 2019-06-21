{ lib, buildAzureMgmtPythonPackage, fetchPypi, isPy3k, python
, azure-common
, azure-mgmt-common
, azure-mgmt-nspkg
, msrest
, msrestazure
}:

buildAzureMgmtPythonPackage rec {
  version = "2.2.0";
  pname = "azure-mgmt-resource";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "173pxgly95dwblp4nj4l70zb0gasibgcjmcynxwa5282plynhgdw";
  };

  propagatedBuildInputs = [
    azure-common
    msrest
    msrestazure
  ] ++ lib.optional (!isPy3k) azure-mgmt-nspkg;

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "Microsoft Azure Resource Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/master/sdk/resources/azure-mgmt-resource";
    license = licenses.mit;
    maintainers = with maintainers; [ olcai mwilsoninsight jonringer ];
  };
}
