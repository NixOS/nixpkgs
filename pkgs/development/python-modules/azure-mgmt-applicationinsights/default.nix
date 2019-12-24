{ lib
, buildPythonPackage
, python
, fetchPypi
, msrest
, msrestazure
, azure-common
, azure-mgmt-nspkg
, isPy3k
}:

buildPythonPackage rec {
  pname = "azure-mgmt-applicationinsights";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1hm6s7vym1y072jqypjgbhps8lza1d5kb8qcpyxnw4zsmsvshdp5";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
  ] ++ lib.optionals (!isPy3k) [
    azure-mgmt-nspkg
  ];

  postInstall = lib.optionalString isPy3k ''
    rm -f $out/${python.sitePackages}/azure/__init__.py
    rm -f $out/${python.sitePackages}/azure/mgmt/__init__.py
  '';

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Application Insights Management Client Library";
    homepage = https://github.com/Azure/sdk-for-python/tree/master/azure-mgmt-applicationinsights;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
