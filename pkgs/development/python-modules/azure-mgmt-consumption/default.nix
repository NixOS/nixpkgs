{ lib
, buildPythonPackage
, fetchPypi
, msrestazure
, azure-common
, azure-mgmt-nspkg
}:

buildPythonPackage rec {
  pname = "azure-mgmt-consumption";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0nqgywknpj2a69an5yrn0c32fk01v5gi05za7dlf4ivwr9s4np83";
  };

  propagatedBuildInputs = [
    msrestazure
    azure-common
    azure-mgmt-nspkg
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Consumption Management Client Library";
    homepage = https://github.com/Azure/sdk-for-python/tree/master/azure-mgmt-consumption;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
