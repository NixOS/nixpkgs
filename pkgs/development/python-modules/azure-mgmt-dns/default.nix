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
  pname = "azure-mgmt-dns";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0zxkcczf01b64qfwj98jqdvnwqahygcyccf37rcxpdcfgpkg9kbf";
  };

  propagatedBuildInputs = [
    msrest
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
    description = "This is the Microsoft Azure DNS Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer mwilsoninsight ];
  };
}
