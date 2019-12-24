{ lib
, buildPythonPackage
, fetchPypi
, python
, isPy3k
, msrest
, msrestazure
, azure-common
, azure-mgmt-nspkg
}:

buildPythonPackage rec {
  pname = "azure-mgmt-servicefabric";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0cirsp8wnsswba6gbmw4s2ljsjwi3855my063gvi2mqr55spvx2n";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
    azure-mgmt-nspkg
  ];

  postInstall = lib.optionalString isPy3k ''
    rm -f $out/${python.sitePackages}/azure/__init__.py
    rm -f $out/${python.sitePackages}/azure/mgmt/__init__.py
  '';

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Service Fabric Management Client Library";
    homepage = https://docs.microsoft.com/en-us/python/api/overview/azure/servicefabric?view=azure-python;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
