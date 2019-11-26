{ lib
, buildPythonPackage
, fetchPypi
, msrestazure
, azure-common
, azure-mgmt-nspkg
, python
, isPy3k
}:

buildPythonPackage rec {
  pname = "azure-mgmt-billing";
  version = "0.2.0"; #pypi's 0.2.0 doesn't build ootb

  src = fetchPypi {
    inherit pname version;
    sha256 = "1li2bcdwdapwwx7xbvgfsq51f2mrwm0qyzih8cjhszcah2rkpxw5";
    extension = "zip";
  };

  propagatedBuildInputs = [
    msrestazure
    azure-common
    azure-mgmt-nspkg
  ];

  preBuild = ''
    rm azure_bdist_wheel.py
    substituteInPlace setup.cfg \
      --replace "azure-namespace-package = azure-mgmt-nspkg" ""
  '';

  postInstall = lib.optionalString isPy3k ''
    rm $out/${python.sitePackages}/azure/__init__.py
    rm $out/${python.sitePackages}/azure/mgmt/__init__.py
  '';

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Billing Client Library";
    homepage = https://github.com/Azure/sdk-for-python/tree/master/azure-mgmt-billing;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
