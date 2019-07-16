{ lib
, buildPythonPackage
, fetchPypi
, msrest
, azure-common
, msrestazure
}:

buildPythonPackage rec {
  pname = "azure-batch";
  version = "6.0.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "d5b0de3db0058cd69baf30e059874094abf865e24ccd82e3cd25f3a48b9676d1";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Batch Client Library";
    homepage = https://docs.microsoft.com/en-us/python/api/overview/azure/batch?view=azure-python;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
