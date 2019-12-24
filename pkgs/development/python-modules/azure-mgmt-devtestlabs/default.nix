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
  pname = "azure-mgmt-devtestlabs";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "b3d5b2919021bf45f0acdd34ab23dc9b0435d9d0a6b472e5008128fb8521e700";
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
    description = "This is the Microsoft Azure DevTestLabs Management Client Library";
    homepage = https://github.com/Azure/sdk-for-python/tree/master/azure-mgmt-devtestlabs;
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer mwilsoninsight ];
  };
}
