{ lib
, buildPythonPackage
, fetchPypi
, python
, isPy3k
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

  postInstall = lib.optionalString isPy3k ''
    rm $out/${python.sitePackages}/azure/__init__.py
    rm $out/${python.sitePackages}/azure/mgmt/__init__.py
  '';

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Consumption Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
