{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, azure-mgmt-nspkg
, msrestazure
, python
, isPy3k
}:

buildPythonPackage rec {
  pname = "azure-mgmt-batchai";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "f1870b0f97d5001cdb66208e5a236c9717a0ed18b34dbfdb238a828f3ca2a683";
  };

  propagatedBuildInputs = [
    msrestazure
    azure-common
    azure-mgmt-nspkg
  ];

  postInstall = lib.optionalString isPy3k ''
    rm $out/${python.sitePackages}/azure/__init__.py
    rm $out/${python.sitePackages}/azure/mgmt/__init__.py
  '';

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Batch AI Management Client Library";
    homepage = https://github.com/Azure/sdk-for-python/tree/master/azure-mgmt-batchai;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
