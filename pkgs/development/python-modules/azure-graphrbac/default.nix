{ lib
, buildPythonPackage
, fetchPypi
, msrest
, msrestazure
, azure-common
}:

buildPythonPackage rec {
  version = "0.61.0";
  pname = "azure-graphrbac";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "4ab27db29d730e4d35f420466500f8ee60a26a8151dbd121a6c353ccd9d4ee55";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Graph RBAC Client Library";
    homepage = https://github.com/Azure/azure-sdk-for-python/tree/master/azure-graphrbac;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
