{ lib
, buildPythonPackage
, fetchPypi
, msrest
, msrestazure
, azure-common
, azure-mgmt-nspkg
}:

buildPythonPackage rec {
  pname = "azure-mgmt-logic";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "d163dfc32e3cfa84f3f8131a75d9e94f5c4595907332cc001e45bf7e4efd5add";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
    azure-mgmt-nspkg
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Logic Apps Management Client Library";
    homepage = https://docs.microsoft.com/en-us/python/api/overview/azure/logic-apps?view=azure-python;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
