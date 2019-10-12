{ lib
, buildPythonPackage
, fetchPypi
, msrest
, azure-common
, msrestazure
}:

buildPythonPackage rec {
  pname = "azure-batch";
  version = "8.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1j8nibnics9vakhqiwnjv7bwril7mfyz1svcvvsrb9a4wbdd12wi";
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
